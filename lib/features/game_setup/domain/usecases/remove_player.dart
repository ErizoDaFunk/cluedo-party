import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/game_setup_repository.dart';

/// Use case to remove a player from the game setup
class RemovePlayer {
  final GameSetupRepository repository;

  RemovePlayer(this.repository);

  Future<Either<Failure, void>> call(String playerId) async {
    // Get current config
    final configResult = await repository.getCurrentConfig();
    
    return configResult.fold(
      (failure) => Left(failure),
      (config) async {
        if (config == null) {
          return const Left(NoActiveGameFailure('No hay configuración activa'));
        }

        // Remove player and save
        final updatedConfig = config.removePlayer(playerId);
        return await repository.saveConfig(updatedConfig);
      },
    );
  }
}

