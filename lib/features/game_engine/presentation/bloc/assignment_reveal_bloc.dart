import 'package:flutter_bloc/flutter_bloc.dart';
import 'assignment_reveal_event.dart';
import 'assignment_reveal_state.dart';
import '../../domain/entities/game.dart';
import '../../../game_setup/domain/entities/player.dart';

/// BLoC for managing assignment revelation
class AssignmentRevealBloc extends Bloc<AssignmentRevealEvent, AssignmentRevealState> {
  final Game game;
  final List<Player> players;
  final List<String>? weapons;
  final List<String>? locations;

  AssignmentRevealBloc({
    required this.game,
    required this.players,
    this.weapons,
    this.locations,
  }) : super(const AssignmentRevealInitial()) {
    on<LoadAssignments>(_onLoadAssignments);
    on<RevealAssignment>(_onRevealAssignment);
    on<CompleteReveal>(_onCompleteReveal);
  }

  Future<void> _onLoadAssignments(
    LoadAssignments event,
    Emitter<AssignmentRevealState> emit,
  ) async {
    emit(const AssignmentRevealLoading());

    // Create player map for quick lookup
    final playerMap = <String, Player>{};
    for (final player in players) {
      playerMap[player.id] = player;
    }

    emit(AssignmentRevealLoaded(
      game: game,
      players: players,
      playerMap: playerMap,
    ));
  }

  Future<void> _onRevealAssignment(
    RevealAssignment event,
    Emitter<AssignmentRevealState> emit,
  ) async {
    if (state is! AssignmentRevealLoaded) return;

    final currentState = state as AssignmentRevealLoaded;
    final assignment = game.getAssignmentForKiller(event.killerId);

    if (assignment == null) {
      emit(const AssignmentRevealError('Assignment not found'));
      return;
    }

    if (assignment.isRevealed) {
      emit(const AssignmentRevealError('Assignment already revealed'));
      return;
    }

    final killer = currentState.playerMap[assignment.killerId];
    final victim = currentState.playerMap[assignment.victimId];

    if (killer == null || victim == null) {
      emit(const AssignmentRevealError('Player not found'));
      return;
    }

    // Get weapon and location names (they are stored as names in the assignment, not IDs)
    final weaponName = assignment.weaponId;
    final locationName = assignment.locationId;

    // Show the assignment in a revealing state
    emit(AssignmentRevealing(
      assignment: assignment,
      killer: killer,
      victim: victim,
      weaponName: weaponName,
      locationName: locationName,
    ));

    // Wait a bit, then return to loaded state with updated game
    await Future.delayed(const Duration(milliseconds: 500));

    final updatedGame = currentState.game.revealAssignment(event.killerId);

    emit(AssignmentRevealLoaded(
      game: updatedGame,
      players: players,
      playerMap: currentState.playerMap,
    ));
  }

  Future<void> _onCompleteReveal(
    CompleteReveal event,
    Emitter<AssignmentRevealState> emit,
  ) async {
    emit(const AssignmentRevealComplete());
  }
}
