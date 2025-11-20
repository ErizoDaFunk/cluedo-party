import 'package:equatable/equatable.dart';
import '../../domain/entities/room.dart';

abstract class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object?> get props => [];
}

class CreateRoomEvent extends RoomEvent {
  final String playerName;

  const CreateRoomEvent(this.playerName);

  @override
  List<Object?> get props => [playerName];
}

class JoinRoomEvent extends RoomEvent {
  final String roomCode;
  final String playerName;

  const JoinRoomEvent({
    required this.roomCode,
    required this.playerName,
  });

  @override
  List<Object?> get props => [roomCode, playerName];
}

class WatchRoomEvent extends RoomEvent {
  final String roomCode;

  const WatchRoomEvent(this.roomCode);

  @override
  List<Object?> get props => [roomCode];
}

class StartGameEvent extends RoomEvent {
  final String roomCode;

  const StartGameEvent(this.roomCode);

  @override
  List<Object?> get props => [roomCode];
}

class LeaveRoomEvent extends RoomEvent {
  const LeaveRoomEvent();
}

// Internal event for stream updates
class RoomDataReceived extends RoomEvent {
  final Room room;

  const RoomDataReceived(this.room);

  @override
  List<Object?> get props => [room];
}
