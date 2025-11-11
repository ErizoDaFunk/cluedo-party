import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../game_engine/domain/entities/location.dart';
import '../repositories/items_repository.dart';

/// Use case to retrieve all available locations
class GetLocations {
  final ItemsRepository repository;

  GetLocations(this.repository);

  Future<Either<Failure, List<Location>>> call() async {
    return await repository.getLocations();
  }
}

