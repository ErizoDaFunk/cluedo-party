import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/game_constants.dart';
import '../../../domain/entities/player.dart';
import '../../bloc/game_setup_bloc.dart';
import '../../bloc/game_setup_event.dart';
import '../add_player_dialog.dart';
import '../player_list_widget.dart';

/// Step 1: Player setup
class PlayerSetupStep extends StatelessWidget {
  final List<Player> players;

  const PlayerSetupStep({
    super.key,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Añade los jugadores que participarán en la partida',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Mínimo ${GameConstants.minPlayers} jugadores',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
        const SizedBox(height: 24),
        
        // Player count
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                GameConstants.players,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '${players.length} / ${GameConstants.maxPlayers}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: players.length >= GameConstants.minPlayers
                          ? Colors.green
                          : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Add player button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              final playerName = await showDialog<String>(
                context: context,
                builder: (context) => const AddPlayerDialog(),
              );

              if (playerName != null && playerName.isNotEmpty) {
                if (context.mounted) {
                  context.read<GameSetupBloc>().add(AddPlayerEvent(playerName));
                }
              }
            },
            icon: const Icon(Icons.person_add),
            label: Text(GameConstants.addPlayer),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Player list
        if (players.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'No hay jugadores añadidos',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: 300,
            child: PlayerListWidget(players: players),
          ),
      ],
    );
  }
}
