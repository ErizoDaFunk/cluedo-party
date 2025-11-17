import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/room.dart';

/// Firestore model for Room
class RoomModel {
  final String code;
  final String hostId;
  final String status;
  final DateTime createdAt;
  final Map<String, RoomPlayerModel> players;

  const RoomModel({
    required this.code,
    required this.hostId,
    required this.status,
    required this.createdAt,
    required this.players,
  });

  /// Convert from Firestore document to RoomModel
  factory RoomModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    final playersData = data['players'] as Map<String, dynamic>? ?? {};
    final players = playersData.map(
      (key, value) => MapEntry(
        key,
        RoomPlayerModel.fromMap(value as Map<String, dynamic>),
      ),
    );

    return RoomModel(
      code: data['code'] as String,
      hostId: data['hostId'] as String,
      status: data['status'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      players: players,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'code': code,
      'hostId': hostId,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'players': players.map((key, value) => MapEntry(key, value.toMap())),
    };
  }

  /// Convert from domain entity to model
  factory RoomModel.fromEntity(Room room) {
    return RoomModel(
      code: room.code,
      hostId: room.hostId,
      status: _roomStatusToString(room.status),
      createdAt: room.createdAt,
      players: room.players.map(
        (key, value) => MapEntry(key, RoomPlayerModel.fromEntity(value)),
      ),
    );
  }

  /// Convert to domain entity
  Room toEntity() {
    return Room(
      code: code,
      hostId: hostId,
      status: _stringToRoomStatus(status),
      createdAt: createdAt,
      players: players.map(
        (key, value) => MapEntry(key, value.toEntity()),
      ),
    );
  }

  static String _roomStatusToString(RoomStatus status) {
    switch (status) {
      case RoomStatus.waiting:
        return 'waiting';
      case RoomStatus.playing:
        return 'playing';
      case RoomStatus.finished:
        return 'finished';
    }
  }

  static RoomStatus _stringToRoomStatus(String status) {
    switch (status) {
      case 'waiting':
        return RoomStatus.waiting;
      case 'playing':
        return RoomStatus.playing;
      case 'finished':
        return RoomStatus.finished;
      default:
        return RoomStatus.waiting;
    }
  }
}

/// Firestore model for RoomPlayer
class RoomPlayerModel {
  final String id;
  final String name;
  final bool isAlive;
  final String? targetId;
  final int killCount;
  final bool isHost;

  const RoomPlayerModel({
    required this.id,
    required this.name,
    required this.isAlive,
    this.targetId,
    required this.killCount,
    required this.isHost,
  });

  /// Convert from Map to RoomPlayerModel
  factory RoomPlayerModel.fromMap(Map<String, dynamic> map) {
    return RoomPlayerModel(
      id: map['id'] as String,
      name: map['name'] as String,
      isAlive: map['isAlive'] as bool? ?? true,
      targetId: map['targetId'] as String?,
      killCount: map['killCount'] as int? ?? 0,
      isHost: map['isHost'] as bool? ?? false,
    );
  }

  /// Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isAlive': isAlive,
      'targetId': targetId,
      'killCount': killCount,
      'isHost': isHost,
    };
  }

  /// Convert from domain entity to model
  factory RoomPlayerModel.fromEntity(RoomPlayer player) {
    return RoomPlayerModel(
      id: player.id,
      name: player.name,
      isAlive: player.isAlive,
      targetId: player.targetId,
      killCount: player.killCount,
      isHost: player.isHost,
    );
  }

  /// Convert to domain entity
  RoomPlayer toEntity() {
    return RoomPlayer(
      id: id,
      name: name,
      isAlive: isAlive,
      targetId: targetId,
      killCount: killCount,
      isHost: isHost,
    );
  }
}
