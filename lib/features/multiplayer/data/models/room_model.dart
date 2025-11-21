import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/room.dart';

/// Firestore model for Room
class RoomModel {
  final String code;
  final String hostId;
  final String status;
  final DateTime createdAt;
  final Map<String, RoomPlayerModel> players;
  final GameSettingsModel settings;

  const RoomModel({
    required this.code,
    required this.hostId,
    required this.status,
    required this.createdAt,
    required this.players,
    required this.settings,
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
      settings: data['settings'] != null
          ? GameSettingsModel.fromMap(data['settings'] as Map<String, dynamic>)
          : const GameSettingsModel(),
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
      'settings': settings.toMap(),
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
      settings: GameSettingsModel.fromEntity(room.settings),
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
      settings: settings.toEntity(),
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
  final String? assignedWeapon;
  final String? assignedLocation;

  const RoomPlayerModel({
    required this.id,
    required this.name,
    required this.isAlive,
    this.targetId,
    required this.killCount,
    required this.isHost,
    this.assignedWeapon,
    this.assignedLocation,
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
      assignedWeapon: map['assignedWeapon'] as String?,
      assignedLocation: map['assignedLocation'] as String?,
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
      'assignedWeapon': assignedWeapon,
      'assignedLocation': assignedLocation,
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
      assignedWeapon: player.assignedWeapon,
      assignedLocation: player.assignedLocation,
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
      assignedWeapon: assignedWeapon,
      assignedLocation: assignedLocation,
    );
  }
}

/// Firestore model for GameSettings
class GameSettingsModel {
  final bool requireWeapon;
  final bool requireLocation;
  final List<String> availableWeapons;
  final List<String> availableLocations;
  final KillVerificationModel killVerification;

  const GameSettingsModel({
    this.requireWeapon = false,
    this.requireLocation = false,
    this.availableWeapons = const [],
    this.availableLocations = const [],
    this.killVerification = const KillVerificationModel(),
  });

  factory GameSettingsModel.fromMap(Map<String, dynamic> map) {
    return GameSettingsModel(
      requireWeapon: map['requireWeapon'] as bool? ?? false,
      requireLocation: map['requireLocation'] as bool? ?? false,
      availableWeapons: (map['availableWeapons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      availableLocations: (map['availableLocations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      killVerification: map['killVerification'] != null
          ? KillVerificationModel.fromMap(
              map['killVerification'] as Map<String, dynamic>)
          : const KillVerificationModel(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'requireWeapon': requireWeapon,
      'requireLocation': requireLocation,
      'availableWeapons': availableWeapons,
      'availableLocations': availableLocations,
      'killVerification': killVerification.toMap(),
    };
  }

  factory GameSettingsModel.fromEntity(GameSettings settings) {
    return GameSettingsModel(
      requireWeapon: settings.requireWeapon,
      requireLocation: settings.requireLocation,
      availableWeapons: settings.availableWeapons,
      availableLocations: settings.availableLocations,
      killVerification:
          KillVerificationModel.fromEntity(settings.killVerification),
    );
  }

  GameSettings toEntity() {
    return GameSettings(
      requireWeapon: requireWeapon,
      requireLocation: requireLocation,
      availableWeapons: availableWeapons,
      availableLocations: availableLocations,
      killVerification: killVerification.toEntity(),
    );
  }
}

/// Firestore model for KillVerification
class KillVerificationModel {
  final bool hostVerifies;
  final bool killerVerifies;
  final bool victimVerifies;

  const KillVerificationModel({
    this.hostVerifies = false,
    this.killerVerifies = true,
    this.victimVerifies = false,
  });

  factory KillVerificationModel.fromMap(Map<String, dynamic> map) {
    return KillVerificationModel(
      hostVerifies: map['hostVerifies'] as bool? ?? false,
      killerVerifies: map['killerVerifies'] as bool? ?? true,
      victimVerifies: map['victimVerifies'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hostVerifies': hostVerifies,
      'killerVerifies': killerVerifies,
      'victimVerifies': victimVerifies,
    };
  }

  factory KillVerificationModel.fromEntity(KillVerification verification) {
    return KillVerificationModel(
      hostVerifies: verification.hostVerifies,
      killerVerifies: verification.killerVerifies,
      victimVerifies: verification.victimVerifies,
    );
  }

  KillVerification toEntity() {
    return KillVerification(
      hostVerifies: hostVerifies,
      killerVerifies: killerVerifies,
      victimVerifies: victimVerifies,
    );
  }
}
