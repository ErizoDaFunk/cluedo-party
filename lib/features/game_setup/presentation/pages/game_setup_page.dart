import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/theme.dart';
import '../../../../core/constants/game_constants.dart';
import '../../domain/entities/player.dart';
import '../bloc/game_setup_bloc.dart';
import '../bloc/game_setup_event.dart';
import '../bloc/game_setup_state.dart';
import '../widgets/add_player_dialog.dart';
import '../widgets/player_list_widget.dart';

class GameSetupPage extends StatelessWidget {
  const GameSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GameConstants.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<GameSetupBloc>().add(const ResetGameSetup());
            },
            tooltip: 'Reiniciar',
          ),
        ],
      ),
      body: BlocConsumer<GameSetupBloc, GameSetupState>(
        listener: (context, state) {
          if (state is GameSetupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          } else if (state is GameSetupSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.successColor,
                duration: const Duration(seconds: 1),
              ),
            );
          } else if (state is GameSetupStarted) {
            // TODO: Navigate to game engine page
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡Juego iniciado! (navegación pendiente)'),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GameSetupLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<Player> players = state is GameSetupLoaded
              ? state.players
              : state is GameSetupSuccess
                  ? state.players
                  : <Player>[];

          final canStart = state is GameSetupLoaded
              ? state.canStart
              : state is GameSetupSuccess
                  ? state.canStart
                  : false;

          return Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(GameConstants.defaultPadding),
                child: Column(
                  children: [
                    Text(
                      GameConstants.players,
                      style: AppTheme.headlineLarge,
                    ),
                    const SizedBox(height: GameConstants.smallPadding),
                    Text(
                      '${players.length} / ${GameConstants.maxPlayers}',
                      style: AppTheme.bodyLarge.copyWith(
                        color: players.length >= GameConstants.minPlayers
                            ? AppTheme.successColor
                            : Colors.grey,
                      ),
                    ),
                    if (players.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: GameConstants.defaultPadding,
                        ),
                        child: Text(
                          GameConstants.addPlayerHint,
                          style: AppTheme.bodyMedium.copyWith(
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (players.isNotEmpty && !canStart)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: GameConstants.defaultPadding,
                        ),
                        child: Text(
                          GameConstants.minPlayersHint,
                          style: AppTheme.bodyMedium.copyWith(
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),

              // Player list
              Expanded(
                child: players.isEmpty
                    ? Center(
                        child: Icon(
                          Icons.person_add,
                          size: 100,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      )
                    : PlayerListWidget(players: players),
              ),

              // Bottom actions
              Container(
                padding: const EdgeInsets.all(GameConstants.defaultPadding),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: canStart
                          ? () {
                              context
                                  .read<GameSetupBloc>()
                                  .add(const StartGameEvent());
                            }
                          : null,
                      icon: const Icon(Icons.play_arrow),
                      label: Text(GameConstants.startGame),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
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
      ),
    );
  }
}

