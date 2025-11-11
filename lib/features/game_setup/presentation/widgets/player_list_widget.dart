import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/theme.dart';
import '../../../../core/constants/game_constants.dart';
import '../../domain/entities/player.dart';
import '../bloc/game_setup_bloc.dart';
import '../bloc/game_setup_event.dart';

class PlayerListWidget extends StatelessWidget {
  final List<Player> players;

  const PlayerListWidget({
    super.key,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: GameConstants.defaultPadding,
        vertical: GameConstants.smallPadding,
      ),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        
        return Dismissible(
          key: Key(player.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: GameConstants.defaultPadding),
            margin: const EdgeInsets.only(bottom: GameConstants.smallPadding),
            decoration: BoxDecoration(
              color: AppTheme.errorColor,
              borderRadius: BorderRadius.circular(GameConstants.borderRadius),
            ),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          confirmDismiss: (direction) async {
            return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Eliminar jugador'),
                content: Text('¿Eliminar a ${player.name}?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(GameConstants.cancel),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      GameConstants.delete,
                      style: const TextStyle(color: AppTheme.errorColor),
                    ),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            context.read<GameSetupBloc>().add(RemovePlayerEvent(player.id));
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: GameConstants.smallPadding),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.primaryColor,
                child: Text(
                  player.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                player.name,
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text('Jugador ${index + 1}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                color: AppTheme.errorColor,
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Eliminar jugador'),
                      content: Text('¿Eliminar a ${player.name}?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(GameConstants.cancel),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(
                            GameConstants.delete,
                            style: const TextStyle(color: AppTheme.errorColor),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    context.read<GameSetupBloc>().add(RemovePlayerEvent(player.id));
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

