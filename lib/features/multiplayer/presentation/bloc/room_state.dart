import 'package:equatable/equatable.dart';
import '../../domain/entities/room.dart';

abstract class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object?> get props => [];
}

class RoomInitial extends RoomState {
  const RoomInitial();
}

class RoomLoading extends RoomState {
  const RoomLoading();
}

class RoomCreated extends RoomState {
  final Room room;
  final String playerId;

  const RoomCreated(this.room, this.playerId);

  @override
  List<Object?> get props => [room, playerId];
}

class RoomJoined extends RoomState {
  final Room room;
  final String playerId;

  const RoomJoined(this.room, this.playerId);

  @override
  List<Object?> get props => [room, playerId];
}

class RoomUpdated extends RoomState {
  final Room room;
  final String playerId;

  const RoomUpdated(this.room, this.playerId);

  @override
  List<Object?> get props => [room, playerId];
}

class RoomError extends RoomState {
  final String message;

  const RoomError(this.message);

  @override
  List<Object?> get props => [message];
}
