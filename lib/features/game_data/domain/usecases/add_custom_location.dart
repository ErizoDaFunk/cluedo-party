import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/items_repository.dart';

/// Use case to add a custom location
class AddCustomLocation {
  final ItemsRepository repository;

  AddCustomLocation(this.repository);

  Future<Either<Failure, void>> call(String name) async {
    if (name.trim().isEmpty) {
      return const Left(ValidationFailure('El nombre del lugar no puede estar vacío'));
    }
    return await repository.addCustomLocation(name.trim());
  }
}

