import 'package:dartz/dartz.dart';
import '../../../../core/constants/game_constants.dart';
import '../../../../core/errors/failures.dart';
import '../entities/game_config.dart';
import '../entities/player.dart';
import '../repositories/game_setup_repository.dart';

/// Use case to add a player to the game setup
class AddPlayer {
  final GameSetupRepository repository;

  AddPlayer(this.repository);

  Future<Either<Failure, void>> call(Player player) async {
    // Validate player name
    if (player.name.trim().isEmpty) {
      return const Left(EmptyPlayerNameFailure());
    }

    // Get current config
    final configResult = await repository.getCurrentConfig();
    
    return configResult.fold(
      (failure) => Left(failure),
      (config) async {
        final currentConfig = config ?? GameConfig(
          players: const [],
          createdAt: DateTime.now(),
        );

        // Check for duplicates
        if (currentConfig.hasPlayer(player.name)) {
          return const Left(DuplicatePlayerFailure());
        }

        // Check max players
        if (currentConfig.playerCount >= GameConstants.maxPlayers) {
          return Left(
            InvalidPlayerCountFailure(
              'Máximo ${GameConstants.maxPlayers} jugadores permitidos',
            ),
          );
        }

        // Add player and save
        final updatedConfig = currentConfig.addPlayer(player);
        return await repository.saveConfig(updatedConfig);
      },
    );
  }
}


