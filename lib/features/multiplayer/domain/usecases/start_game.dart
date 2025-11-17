import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/room.dart';
import '../repositories/room_repository.dart';

class StartGameUseCase {
  final RoomRepository repository;

  StartGameUseCase(this.repository);

  Future<Either<Failure, Room>> call(String roomCode) async {
    return await repository.startGame(roomCode);
  }
}
