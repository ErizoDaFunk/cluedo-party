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

  GameConfigModel({
    required this.playerModels,
    required this.createdAt,
  }) : super(
          players: playerModels,
          createdAt: createdAt,
        );

  /// Create from entity
  factory GameConfigModel.fromEntity(GameConfig config) {
    return GameConfigModel(
      playerModels: config.players
          .map((player) => PlayerModel.fromEntity(player))
          .toList(),
      createdAt: config.createdAt,
    );
  }

  /// Create from JSON
  factory GameConfigModel.fromJson(Map<String, dynamic> json) {
    return GameConfigModel(
      playerModels: (json['players'] as List)
          .map((p) => PlayerModel.fromJson(p as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'players': playerModels.map((p) => p.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

