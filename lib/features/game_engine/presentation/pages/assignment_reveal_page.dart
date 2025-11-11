import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/theme.dart';
import '../../../game_setup/domain/entities/player.dart';
import '../../domain/entities/game.dart';
import '../bloc/assignment_reveal_bloc.dart';
import '../bloc/assignment_reveal_event.dart';
import '../bloc/assignment_reveal_state.dart';

class AssignmentRevealPage extends StatelessWidget {
  final Game game;
  final List<Player> players;

  const AssignmentRevealPage({
    super.key,
    required this.game,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AssignmentRevealBloc(
        game: game,
        players: players,
      )..add(const LoadAssignments()),
      child: const _AssignmentRevealView(),
    );
  }
}

class _AssignmentRevealView extends StatelessWidget {
  const _AssignmentRevealView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Revelación de Asignaciones'),
        centerTitle: true,
      ),
      body: BlocConsumer<AssignmentRevealBloc, AssignmentRevealState>(
        listener: (context, state) {
          if (state is AssignmentRevealError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AssignmentRevealing) {
            _showAssignmentDialog(context, state);
          } else if (state is AssignmentRevealComplete) {
            // TODO: Navigate to active game screen
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is AssignmentRevealLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AssignmentRevealLoaded) {
            return _buildPlayerGrid(context, state);
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildPlayerGrid(BuildContext context, AssignmentRevealLoaded state) {
    return Column(
      children: [
        // Progress indicator
        Container(
          padding: const EdgeInsets.all(24),
          color: AppTheme.darkTheme.colorScheme.surface,
          child: Column(
            children: [
              Text(
                'Jugadores restantes: ${state.unrevealedPlayers.length}/${state.players.length}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: state.game.revealedCount / state.players.length,
                backgroundColor: Colors.grey.shade700,
                minHeight: 8,
              ),
              const SizedBox(height: 16),
              Text(
                'Cada jugador debe tocar su nombre para ver su misión',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade400,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        // Player grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.players.length,
            itemBuilder: (context, index) {
              final player = state.players[index];
              final assignment = state.game.getAssignmentForKiller(player.id);
              final isRevealed = assignment?.isRevealed ?? false;

              return _PlayerCard(
                player: player,
                isRevealed: isRevealed,
                onTap: isRevealed
                    ? null
                    : () {
                        context
                            .read<AssignmentRevealBloc>()
                            .add(RevealAssignment(player.id));
                      },
              );
            },
          ),
        ),

        // Complete button (only when all revealed)
        if (state.allRevealed)
          Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: () {
                context.read<AssignmentRevealBloc>().add(const CompleteReveal());
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 20,
                ),
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'Comenzar Partida',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
      ],
    );
  }

  void _showAssignmentDialog(BuildContext context, AssignmentRevealing state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text('${state.killer.name}, tu misión es...'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _MissionDetail(
              icon: Icons.person_outline,
              label: 'Eliminar a',
              value: state.victim.name,
            ),
            if (state.weaponName != null) ...[
              const SizedBox(height: 16),
              _MissionDetail(
                icon: Icons.sports_martial_arts,
                label: 'Con el arma',
                value: state.weaponName!,
              ),
            ],
            if (state.locationName != null) ...[
              const SizedBox(height: 16),
              _MissionDetail(
                icon: Icons.location_on,
                label: 'En el lugar',
                value: state.locationName!,
              ),
            ],
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Memoriza bien tu misión. No podrás verla de nuevo.',
                      style: TextStyle(
                        color: Colors.orange.shade900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}

class _PlayerCard extends StatelessWidget {
  final Player player;
  final bool isRevealed;
  final VoidCallback? onTap;

  const _PlayerCard({
    required this.player,
    required this.isRevealed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isRevealed ? 1 : 4,
      color: isRevealed ? Colors.grey.shade800 : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isRevealed ? Icons.check_circle : Icons.person,
                size: 48,
                color: isRevealed ? Colors.green : AppTheme.secondaryColor,
              ),
              const SizedBox(height: 12),
              Text(
                player.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isRevealed ? Colors.grey.shade600 : null,
                  decoration: isRevealed ? TextDecoration.lineThrough : null,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (isRevealed) ...[
                const SizedBox(height: 8),
                Text(
                  'Revelado',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MissionDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MissionDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
