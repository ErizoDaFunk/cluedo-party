import 'package:equatable/equatable.dart';

/// Entity representing a multiplayer game room
class Room extends Equatable {
  final String code;
  final String hostId;
  final RoomStatus status;
  final DateTime createdAt;
  final Map<String, RoomPlayer> players;
  final GameSettings settings;

  const Room({
    required this.code,
    required this.hostId,
    required this.status,
    required this.createdAt,
    required this.players,
    required this.settings,
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
    GameSettings? settings,
  }) {
    return Room(
      code: code ?? this.code,
      hostId: hostId ?? this.hostId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      players: players ?? this.players,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object?> get props => [code, hostId, status, createdAt, players, settings];
}

/// Entity representing a player in a room
class RoomPlayer extends Equatable {
  final String id;
  final String name;
  final bool isAlive;
  final String? targetId;
  final int killCount;
  final bool isHost;
  final String? assignedWeapon;
  final String? assignedLocation;

  const RoomPlayer({
    required this.id,
    required this.name,
    this.isAlive = true,
    this.targetId,
    this.killCount = 0,
    this.isHost = false,
    this.assignedWeapon,
    this.assignedLocation,
  });

  RoomPlayer copyWith({
    String? id,
    String? name,
    bool? isAlive,
    String? targetId,
    int? killCount,
    bool? isHost,
    String? assignedWeapon,
    String? assignedLocation,
  }) {
    return RoomPlayer(
      id: id ?? this.id,
      name: name ?? this.name,
      isAlive: isAlive ?? this.isAlive,
      targetId: targetId ?? this.targetId,
      killCount: killCount ?? this.killCount,
      isHost: isHost ?? this.isHost,
      assignedWeapon: assignedWeapon ?? this.assignedWeapon,
      assignedLocation: assignedLocation ?? this.assignedLocation,
    );
  }

  @override
  List<Object?> get props => [id, name, isAlive, targetId, killCount, isHost, assignedWeapon, assignedLocation];
}

/// Room status enum
enum RoomStatus {
  waiting,
  playing,
  finished,
}

/// Game settings entity
class GameSettings extends Equatable {
  final bool requireWeapon;
  final bool requireLocation;
  final List<String> availableWeapons;
  final List<String> availableLocations;
  final KillVerification killVerification;

  const GameSettings({
    this.requireWeapon = false,
    this.requireLocation = false,
    this.availableWeapons = const [],
    this.availableLocations = const [],
    this.killVerification = const KillVerification(),
  });

  GameSettings copyWith({
    bool? requireWeapon,
    bool? requireLocation,
    List<String>? availableWeapons,
    List<String>? availableLocations,
    KillVerification? killVerification,
  }) {
    return GameSettings(
      requireWeapon: requireWeapon ?? this.requireWeapon,
      requireLocation: requireLocation ?? this.requireLocation,
      availableWeapons: availableWeapons ?? this.availableWeapons,
      availableLocations: availableLocations ?? this.availableLocations,
      killVerification: killVerification ?? this.killVerification,
    );
  }

  @override
  List<Object?> get props => [
        requireWeapon,
        requireLocation,
        availableWeapons,
        availableLocations,
        killVerification,
      ];
}

/// Kill verification settings
class KillVerification extends Equatable {
  final bool hostVerifies;
  final bool killerVerifies;
  final bool victimVerifies;

  const KillVerification({
    this.hostVerifies = false,
    this.killerVerifies = true,
    this.victimVerifies = false,
  });

  KillVerification copyWith({
    bool? hostVerifies,
    bool? killerVerifies,
    bool? victimVerifies,
  }) {
    return KillVerification(
      hostVerifies: hostVerifies ?? this.hostVerifies,
      killerVerifies: killerVerifies ?? this.killerVerifies,
      victimVerifies: victimVerifies ?? this.victimVerifies,
    );
  }

  @override
  List<Object?> get props => [hostVerifies, killerVerifies, victimVerifies];
}
