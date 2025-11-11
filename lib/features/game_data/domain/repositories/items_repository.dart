import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../game_engine/domain/entities/weapon.dart';
import '../../../game_engine/domain/entities/location.dart';

/// Repository interface for managing weapons and locations
abstract class ItemsRepository {
  /// Get all available weapons (default + custom)
  Future<Either<Failure, List<Weapon>>> getWeapons();

  /// Get all available locations (default + custom)
  Future<Either<Failure, List<Location>>> getLocations();

  /// Add a custom weapon
  Future<Either<Failure, void>> addCustomWeapon(String name);

  /// Add a custom location
  Future<Either<Failure, void>> addCustomLocation(String name);

  /// Remove a custom weapon by id
  Future<Either<Failure, void>> removeCustomWeapon(String id);

  /// Remove a custom location by id
  Future<Either<Failure, void>> removeCustomLocation(String id);

  /// Get only default weapons
  Future<Either<Failure, List<Weapon>>> getDefaultWeapons();

  /// Get only default locations
  Future<Either<Failure, List<Location>>> getDefaultLocations();

  /// Get only custom weapons
  Future<Either<Failure, List<Weapon>>> getCustomWeapons();

  /// Get only custom locations
  Future<Either<Failure, List<Location>>> getCustomLocations();
}

