import 'package:hive/hive.dart';
import '../../domain/entities/game_config.dart';
import 'player_model.dart';

part 'game_config_model.g.dart';

@HiveType(typeId: 3)
class GameConfigModel extends GameConfig {
  @HiveField(0)
  final List<PlayerModel> playerModels;

  @HiveField(1)
  @override
  final DateTime createdAt;

  @HiveField(2)
  @override
  final bool requireWeapon;

  @HiveField(3)
  @override
  final bool requireLocation;

  @HiveField(4)
  @override
  final List<String>? customWeapons;

  @HiveField(5)
  @override
  final List<String>? customLocations;

  GameConfigModel({
    required this.playerModels,
    required this.createdAt,
    this.requireWeapon = true,
    this.requireLocation = true,
    this.customWeapons,
    this.customLocations,
  }) : super(
          players: playerModels,
          createdAt: createdAt,
          requireWeapon: requireWeapon,
          requireLocation: requireLocation,
          customWeapons: customWeapons,
          customLocations: customLocations,
        );

  /// Create from entity
  factory GameConfigModel.fromEntity(GameConfig config) {
    return GameConfigModel(
      playerModels: config.players
          .map((player) => PlayerModel.fromEntity(player))
          .toList(),
      createdAt: config.createdAt,
      requireWeapon: config.requireWeapon,
      requireLocation: config.requireLocation,
      customWeapons: config.customWeapons,
      customLocations: config.customLocations,
    );
  }

  /// Create from JSON
  factory GameConfigModel.fromJson(Map<String, dynamic> json) {
    return GameConfigModel(
      playerModels: (json['players'] as List)
          .map((p) => PlayerModel.fromJson(p as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      requireWeapon: json['requireWeapon'] as bool? ?? true,
      requireLocation: json['requireLocation'] as bool? ?? true,
      customWeapons: (json['customWeapons'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      customLocations: (json['customLocations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'players': playerModels.map((p) => p.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'requireWeapon': requireWeapon,
      'requireLocation': requireLocation,
      'customWeapons': customWeapons,
      'customLocations': customLocations,
    };
  }
}

