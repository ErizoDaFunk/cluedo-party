import 'package:dartz/dartz.dart';
import '../../../../core/constants/game_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/game_config.dart';
import '../../domain/entities/player.dart';
import '../../domain/repositories/game_setup_repository.dart';
import '../datasources/local_game_datasource.dart';
import '../models/game_config_model.dart';

/// Implementation of GameSetupRepository
class GameSetupRepositoryImpl implements GameSetupRepository {
  final LocalGameDataSource localDataSource;

  GameSetupRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, GameConfig?>> getCurrentConfig() async {
    try {
      final config = await localDataSource.getCurrentConfig();
      return Right(config);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Error getting current config: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveConfig(GameConfig config) async {
    try {
      final model = GameConfigModel.fromEntity(config);
      await localDataSource.saveConfig(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Error saving config: $e'));
    }
  }

  @override
  Future<Either<Failure, GameConfig>> addPlayer(Player player) async {
    try {
      final currentConfig = await localDataSource.getCurrentConfig();
      
      final config = currentConfig ?? GameConfigModel(
        playerModels: const [],
        createdAt: DateTime.now(),
        requireWeapon: true,
        requireLocation: true,
        customWeapons: GameConstants.defaultWeapons.toList(),
        customLocations: GameConstants.defaultLocations.toList(),
      );

      AppLogger.debug('GameSetupRepo', 'addPlayer - Config created/loaded');
      AppLogger.debug('GameSetupRepo', 'Current config is null: ${currentConfig == null}');
      AppLogger.debug('GameSetupRepo', 'Weapons: ${config.customWeapons?.length ?? 0}');
      AppLogger.debug('GameSetupRepo', 'Locations: ${config.customLocations?.length ?? 0}');

      // Validate
      if (config.hasPlayer(player.name)) {
        return const Left(DuplicatePlayerFailure());
      }

      if (config.playerCount >= GameConstants.maxPlayers) {
        return const Left(InvalidPlayerCountFailure());
      }

      final updatedConfig = config.addPlayer(player);
      final model = GameConfigModel.fromEntity(updatedConfig);
      
      AppLogger.debug('GameSetupRepo', 'After addPlayer - Weapons: ${updatedConfig.customWeapons?.length ?? 0}');
      AppLogger.debug('GameSetupRepo', 'After addPlayer - Locations: ${updatedConfig.customLocations?.length ?? 0}');
      
      await localDataSource.saveConfig(model);
      
      return Right(updatedConfig);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Error adding player: $e'));
    }
  }

  @override
  Future<Either<Failure, GameConfig>> removePlayer(String playerId) async {
    try {
      final currentConfig = await localDataSource.getCurrentConfig();
      
      if (currentConfig == null) {
        return const Left(NoActiveGameFailure());
      }

      final updatedConfig = currentConfig.removePlayer(playerId);
      final model = GameConfigModel.fromEntity(updatedConfig);
      await localDataSource.saveConfig(model);
      
      return Right(updatedConfig);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Error removing player: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearConfig() async {
    try {
      await localDataSource.clearConfig();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Error clearing config: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> validateConfig(GameConfig config) async {
    try {
      if (config.playerCount < GameConstants.minPlayers) {
        return const Left(InvalidPlayerCountFailure());
      }

      if (config.playerCount > GameConstants.maxPlayers) {
        return const Left(InvalidPlayerCountFailure());
      }

      return const Right(true);
    } catch (e) {
      return Left(ValidationFailure('Error validating config: $e'));
    }
  }
}

