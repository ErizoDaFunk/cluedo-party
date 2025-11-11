import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../game_engine/domain/entities/location.dart';
import '../../../game_engine/domain/entities/weapon.dart';
import '../../domain/repositories/items_repository.dart';
import '../datasources/custom_items_datasource.dart';
import '../datasources/default_items_datasource.dart';

/// Implementation of ItemsRepository
class ItemsRepositoryImpl implements ItemsRepository {
  final DefaultItemsDataSource defaultDataSource;
  final CustomItemsDataSource customDataSource;

  ItemsRepositoryImpl({
    required this.defaultDataSource,
    required this.customDataSource,
  });

  @override
  Future<Either<Failure, List<Weapon>>> getWeapons() async {
    try {
      final defaultWeapons = defaultDataSource.getDefaultWeapons();
      final customWeapons = await customDataSource.getCustomWeapons();
      
      return Right([...defaultWeapons, ...customWeapons]);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Error getting weapons: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Location>>> getLocations() async {
    try {
      final defaultLocations = defaultDataSource.getDefaultLocations();
      final customLocations = await customDataSource.getCustomLocations();
      
      return Right([...defaultLocations, ...customLocations]);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Error getting locations: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addCustomWeapon(String name) async {
    try {
      await customDataSource.addCustomWeapon(name);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Error adding custom weapon: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addCustomLocation(String name) async {
    try {
      await customDataSource.addCustomLocation(name);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Error adding custom location: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> removeCustomWeapon(String id) async {
    try {
      await customDataSource.removeCustomWeapon(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Error removing custom weapon: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> removeCustomLocation(String id) async {
    try {
      await customDataSource.removeCustomLocation(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Error removing custom location: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Weapon>>> getDefaultWeapons() async {
    try {
      final weapons = defaultDataSource.getDefaultWeapons();
      return Right(weapons);
    } catch (e) {
      return Left(CacheFailure('Error getting default weapons: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Location>>> getDefaultLocations() async {
    try {
      final locations = defaultDataSource.getDefaultLocations();
      return Right(locations);
    } catch (e) {
      return Left(CacheFailure('Error getting default locations: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Weapon>>> getCustomWeapons() async {
    try {
      final weapons = await customDataSource.getCustomWeapons();
      return Right(weapons);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Error getting custom weapons: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Location>>> getCustomLocations() async {
    try {
      final locations = await customDataSource.getCustomLocations();
      return Right(locations);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Error getting custom locations: $e'));
    }
  }
}

