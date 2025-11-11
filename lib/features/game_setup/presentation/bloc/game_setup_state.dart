import 'package:equatable/equatable.dart';
import '../../domain/entities/player.dart';

/// Base class for GameSetup states
abstract class GameSetupState extends Equatable {
  const GameSetupState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class GameSetupInitial extends GameSetupState {
  const GameSetupInitial();
}

/// Loading state
class GameSetupLoading extends GameSetupState {
  const GameSetupLoading();
}

/// Loaded state with players
class GameSetupLoaded extends GameSetupState {
  final List<Player> players;
  final bool canStart;

  const GameSetupLoaded({
    required this.players,
    required this.canStart,
  });

  @override
  List<Object?> get props => [players, canStart];
}

/// Error state
class GameSetupError extends GameSetupState {
  final String message;

  const GameSetupError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Success state (e.g., player added)
class GameSetupSuccess extends GameSetupState {
  final String message;
  final List<Player> players;
  final bool canStart;

  const GameSetupSuccess({
    required this.message,
    required this.players,
    required this.canStart,
  });

  @override
  List<Object?> get props => [message, players, canStart];
}

/// Game started state - navigate to game
class GameSetupStarted extends GameSetupState {
  final List<Player> players;

  const GameSetupStarted(this.players);

  @override
  List<Object?> get props => [players];
}

