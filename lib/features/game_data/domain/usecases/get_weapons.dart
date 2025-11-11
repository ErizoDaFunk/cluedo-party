import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../game_engine/domain/entities/weapon.dart';
import '../repositories/items_repository.dart';

/// Use case to retrieve all available weapons
class GetWeapons {
  final ItemsRepository repository;

  GetWeapons(this.repository);

  Future<Either<Failure, List<Weapon>>> call() async {
    return await repository.getWeapons();
  }
}

