import 'package:equatable/equatable.dart';

abstract class AssignmentRevealEvent extends Equatable {
  const AssignmentRevealEvent();

  @override
  List<Object?> get props => [];
}

/// Load the current game with all assignments
class LoadAssignments extends AssignmentRevealEvent {
  const LoadAssignments();
}

/// Reveal an assignment for a specific player
class RevealAssignment extends AssignmentRevealEvent {
  final String killerId;

  const RevealAssignment(this.killerId);

  @override
  List<Object?> get props => [killerId];
}

/// Navigate to next screen when all assignments revealed
class CompleteReveal extends AssignmentRevealEvent {
  const CompleteReveal();
}
