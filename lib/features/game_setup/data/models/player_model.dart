import 'package:hive/hive.dart';
import '../../domain/entities/player.dart';

part 'player_model.g.dart';

@HiveType(typeId: 2)
class PlayerModel extends Player {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String name;

  @HiveField(2)
  @override
  final bool isRevealed;

  const PlayerModel({
    required this.id,
    required this.name,
    this.isRevealed = false,
  }) : super(id: id, name: name, isRevealed: isRevealed);

  /// Create from entity
  factory PlayerModel.fromEntity(Player player) {
    return PlayerModel(
      id: player.id,
      name: player.name,
      isRevealed: player.isRevealed,
    );
  }

  /// Create from JSON
  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      isRevealed: json['isRevealed'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isRevealed': isRevealed,
    };
  }

  /// Create a copy with modified fields
  PlayerModel copyWith({
    String? id,
    String? name,
    bool? isRevealed,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isRevealed: isRevealed ?? this.isRevealed,
    );
  }
}

