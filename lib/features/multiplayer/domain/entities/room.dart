import 'package:equatable/equatable.dart';

/// Entity representing a multiplayer game room
class Room extends Equatable {
  final String code;
  final String hostId;
  final RoomStatus status;
  final DateTime createdAt;
  final Map<String, RoomPlayer> players;

  const Room({
    required this.code,
    required this.hostId,
    required this.status,
    required this.createdAt,
    required this.players,
  });

  bool get isWaiting => status == RoomStatus.waiting;
  bool get isPlaying => status == RoomStatus.playing;
  bool get isFinished => status == RoomStatus.finished;

  int get playerCount => players.length;
  
  Room copyWith({
    String? code,
    String? hostId,
    RoomStatus? status,
    DateTime? createdAt,
    Map<String, RoomPlayer>? players,
  }) {
    return Room(
      code: code ?? this.code,
      hostId: hostId ?? this.hostId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      players: players ?? this.players,
    );
  }

  @override
  List<Object?> get props => [code, hostId, status, createdAt, players];
}

/// Entity representing a player in a room
class RoomPlayer extends Equatable {
  final String id;
  final String name;
  final bool isAlive;
  final String? targetId;
  final int killCount;
  final bool isHost;

  const RoomPlayer({
    required this.id,
    required this.name,
    this.isAlive = true,
    this.targetId,
    this.killCount = 0,
    this.isHost = false,
  });

  RoomPlayer copyWith({
    String? id,
    String? name,
    bool? isAlive,
    String? targetId,
    int? killCount,
    bool? isHost,
  }) {
    return RoomPlayer(
      id: id ?? this.id,
      name: name ?? this.name,
      isAlive: isAlive ?? this.isAlive,
      targetId: targetId ?? this.targetId,
      killCount: killCount ?? this.killCount,
      isHost: isHost ?? this.isHost,
    );
  }

  @override
  List<Object?> get props => [id, name, isAlive, targetId, killCount, isHost];
}

/// Room status enum
enum RoomStatus {
  waiting,
  playing,
  finished,
}
