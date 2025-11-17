import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/room.dart';
import '../repositories/room_repository.dart';

class CreateRoomUseCase {
  final RoomRepository repository;

  CreateRoomUseCase(this.repository);

  Future<Either<Failure, Room>> call({
    required String playerName,
    required String playerId,
  }) async {
    if (playerName.trim().isEmpty) {
      return const Left(EmptyPlayerNameFailure());
    }

    return await repository.createRoom(
      playerName: playerName.trim(),
      playerId: playerId,
    );
  }
}
