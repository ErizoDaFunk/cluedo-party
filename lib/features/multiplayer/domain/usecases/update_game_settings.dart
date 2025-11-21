import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/room.dart';
import '../repositories/room_repository.dart';

class UpdateGameSettingsUseCase {
  final RoomRepository repository;

  UpdateGameSettingsUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String roomCode,
    required GameSettings settings,
  }) async {
    return await repository.updateGameSettings(
      roomCode: roomCode,
      settings: settings,
    );
  }
}
