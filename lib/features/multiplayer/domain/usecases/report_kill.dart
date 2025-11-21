import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/room_repository.dart';

class ReportKillUseCase {
  final RoomRepository repository;

  ReportKillUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String roomCode,
    required String killerId,
    required String victimId,
  }) async {
    return await repository.reportKill(
      roomCode: roomCode,
      killerId: killerId,
      victimId: victimId,
    );
  }
}
