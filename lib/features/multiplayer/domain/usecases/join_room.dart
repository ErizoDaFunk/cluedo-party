import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/room.dart';
import '../repositories/room_repository.dart';

class JoinRoomUseCase {
  final RoomRepository repository;

  JoinRoomUseCase(this.repository);

  Future<Either<Failure, Room>> call({
    required String roomCode,
    required String playerName,
    required String playerId,
  }) async {
    if (roomCode.trim().isEmpty) {
      return const Left(RoomNotFoundFailure('Código de sala vacío'));
    }

    if (playerName.trim().isEmpty) {
      return const Left(EmptyPlayerNameFailure());
    }

    return await repository.joinRoom(
      roomCode: roomCode.trim().toUpperCase(),
      playerName: playerName.trim(),
      playerId: playerId,
    );
  }
}
