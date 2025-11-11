import 'package:hive/hive.dart';
import '../../domain/entities/game.dart';
import 'assignment_model.dart';

part 'game_model.g.dart';

@HiveType(typeId: 5)
class GameModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final List<AssignmentModel> assignmentModels;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final bool isComplete;

  GameModel({
    required this.id,
    required this.assignmentModels,
    required this.createdAt,
    this.isComplete = false,
  });

  /// Convert from domain entity
  factory GameModel.fromEntity(Game game) {
    return GameModel(
      id: game.id,
      assignmentModels: game.assignments
          .map((assignment) => AssignmentModel.fromEntity(assignment))
          .toList(),
      createdAt: game.createdAt,
      isComplete: game.isComplete,
    );
  }

  /// Convert to domain entity
  Game toEntity() {
    return Game(
      id: id,
      assignments: assignmentModels.map((model) => model.toEntity()).toList(),
      createdAt: createdAt,
      isComplete: isComplete,
    );
  }

  /// Create from JSON
  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'] as String,
      assignmentModels: (json['assignments'] as List)
          .map((item) => AssignmentModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isComplete: json['isComplete'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assignments': assignmentModels.map((model) => model.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'isComplete': isComplete,
    };
  }
}
