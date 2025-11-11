import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/items_repository.dart';

/// Use case to add a custom weapon
class AddCustomWeapon {
  final ItemsRepository repository;

  AddCustomWeapon(this.repository);

  Future<Either<Failure, void>> call(String name) async {
    if (name.trim().isEmpty) {
      return const Left(ValidationFailure('El nombre del arma no puede estar vacío'));
    }
    return await repository.addCustomWeapon(name.trim());
  }
}

