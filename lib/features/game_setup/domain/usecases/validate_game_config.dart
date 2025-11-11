import 'package:dartz/dartz.dart';
import '../../../../core/constants/game_constants.dart';
import '../../../../core/errors/failures.dart';
import '../entities/game_config.dart';
import '../repositories/game_setup_repository.dart';

/// Use case to validate if game configuration is ready to start
class ValidateGameConfig {
  final GameSetupRepository repository;

  ValidateGameConfig(this.repository);

  Future<Either<Failure, bool>> call(GameConfig config) async {
    // Check minimum players
    if (config.playerCount < GameConstants.minPlayers) {
      return Left(
        InvalidPlayerCountFailure(
          'Se necesitan al menos ${GameConstants.minPlayers} jugadores',
        ),
      );
    }

    // Check maximum players
    if (config.playerCount > GameConstants.maxPlayers) {
      return Left(
        InvalidPlayerCountFailure(
          'Máximo ${GameConstants.maxPlayers} jugadores permitidos',
        ),
      );
    }

    // All validations passed
    return const Right(true);
  }
}

