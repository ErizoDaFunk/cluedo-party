import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/room.dart';

/// Repository interface for Room operations
abstract class RoomRepository {
  /// Create a new room with a unique code
  Future<Either<Failure, Room>> createRoom({
    required String playerName,
    required String playerId,
  });

  /// Join an existing room by code
  Future<Either<Failure, Room>> joinRoom({
    required String roomCode,
    required String playerName,
    required String playerId,
  });

  /// Get room by code
  Future<Either<Failure, Room>> getRoomByCode(String code);

  /// Watch room changes in real-time
  Stream<Either<Failure, Room>> watchRoom(String code);

  /// Update room status
  Future<Either<Failure, void>> updateRoomStatus({
    required String roomCode,
    required RoomStatus status,
  });

  /// Add player to room
  Future<Either<Failure, void>> addPlayerToRoom({
    required String roomCode,
    required RoomPlayer player,
  });

  /// Remove player from room
  Future<Either<Failure, void>> removePlayerFromRoom({
    required String roomCode,
    required String playerId,
  });

  /// Update player in room
  Future<Either<Failure, void>> updatePlayer({
    required String roomCode,
    required RoomPlayer player,
  });

  /// Delete room
  Future<Either<Failure, void>> deleteRoom(String roomCode);

  /// Start game (assign targets)
  Future<Either<Failure, Room>> startGame(String roomCode);

  /// Update game settings
  Future<Either<Failure, void>> updateGameSettings({
    required String roomCode,
    required GameSettings settings,
  });
}
