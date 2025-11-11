import 'package:equatable/equatable.dart';
import '../../../game_setup/domain/entities/player.dart';
import '../../domain/entities/assignment.dart';
import '../../domain/entities/game.dart';

abstract class AssignmentRevealState extends Equatable {
  const AssignmentRevealState();

  @override
  List<Object?> get props => [];
}

class AssignmentRevealInitial extends AssignmentRevealState {
  const AssignmentRevealInitial();
}

class AssignmentRevealLoading extends AssignmentRevealState {
  const AssignmentRevealLoading();
}

class AssignmentRevealLoaded extends AssignmentRevealState {
  final Game game;
  final List<Player> players;
  final Map<String, Player> playerMap; // killerId -> Player

  const AssignmentRevealLoaded({
    required this.game,
    required this.players,
    required this.playerMap,
  });

  /// Get unrevealed player killers
  List<Player> get unrevealedPlayers {
    return players
        .where((player) {
          final assignment = game.getAssignmentForKiller(player.id);
          return assignment != null && !assignment.isRevealed;
        })
        .toList();
  }

  /// Get revealed player killers
  List<Player> get revealedPlayers {
    return players
        .where((player) {
          final assignment = game.getAssignmentForKiller(player.id);
          return assignment != null && assignment.isRevealed;
        })
        .toList();
  }

  /// Check if all assignments revealed
  bool get allRevealed => game.allRevealed;

  @override
  List<Object?> get props => [game, players, playerMap];
}

class AssignmentRevealing extends AssignmentRevealState {
  final Assignment assignment;
  final Player killer;
  final Player victim;
  final String? weaponName;
  final String? locationName;

  const AssignmentRevealing({
    required this.assignment,
    required this.killer,
    required this.victim,
    this.weaponName,
    this.locationName,
  });

  @override
  List<Object?> get props => [assignment, killer, victim, weaponName, locationName];
}

class AssignmentRevealError extends AssignmentRevealState {
  final String message;

  const AssignmentRevealError(this.message);

  @override
  List<Object?> get props => [message];
}

class AssignmentRevealComplete extends AssignmentRevealState {
  const AssignmentRevealComplete();
}
