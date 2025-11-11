import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/game_config.dart';
import '../entities/player.dart';

/// Repository interface for game setup operations
abstract class GameSetupRepository {
  /// Get current game configuration (if exists)
  Future<Either<Failure, GameConfig?>> getCurrentConfig();

  /// Save game configuration
  Future<Either<Failure, void>> saveConfig(GameConfig config);

  /// Add a player to the current configuration
  Future<Either<Failure, GameConfig>> addPlayer(Player player);

  /// Remove a player from the current configuration
  Future<Either<Failure, GameConfig>> removePlayer(String playerId);

  /// Clear current configuration
  Future<Either<Failure, void>> clearConfig();

  /// Validate if configuration is ready to start game
  Future<Either<Failure, bool>> validateConfig(GameConfig config);
}

