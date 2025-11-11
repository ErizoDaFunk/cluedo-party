import 'package:equatable/equatable.dart';
import 'assignment.dart';

/// Represents an active game with all player assignments
class Game extends Equatable {
  final String id;
  final List<Assignment> assignments;
  final DateTime createdAt;
  final bool isComplete;

  const Game({
    required this.id,
    required this.assignments,
    required this.createdAt,
    this.isComplete = false,
  });

  /// Check if all assignments have been revealed
  bool get allRevealed => assignments.every((a) => a.isRevealed);

  /// Get number of revealed assignments
  int get revealedCount => assignments.where((a) => a.isRevealed).length;

  /// Get assignment for a specific killer
  Assignment? getAssignmentForKiller(String killerId) {
    try {
      return assignments.firstWhere((a) => a.killerId == killerId);
    } catch (e) {
      return null;
    }
  }

  /// Reveal an assignment by killer ID
  Game revealAssignment(String killerId) {
    final updatedAssignments = assignments.map((assignment) {
      if (assignment.killerId == killerId) {
        return assignment.reveal();
      }
      return assignment;
    }).toList();

    return Game(
      id: id,
      assignments: updatedAssignments,
      createdAt: createdAt,
      isComplete: updatedAssignments.every((a) => a.isRevealed),
    );
  }

  /// Create a copy with modified fields
  Game copyWith({
    String? id,
    List<Assignment>? assignments,
    DateTime? createdAt,
    bool? isComplete,
  }) {
    return Game(
      id: id ?? this.id,
      assignments: assignments ?? this.assignments,
      createdAt: createdAt ?? this.createdAt,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  @override
  List<Object?> get props => [id, assignments, createdAt, isComplete];
}
