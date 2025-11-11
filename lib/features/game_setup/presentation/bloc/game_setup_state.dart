import 'package:equatable/equatable.dart';
import '../../domain/entities/game_config.dart';
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

/// Loaded state with game configuration
class GameSetupLoaded extends GameSetupState {
  final List<Player> players;
  final bool canStart;
  final GameConfig? config;

  const GameSetupLoaded({
    required this.players,
    required this.canStart,
    this.config,
  });

  bool get requireWeapon => config?.requireWeapon ?? true;
  bool get requireLocation => config?.requireLocation ?? true;
  List<String>? get customWeapons => config?.customWeapons;
  List<String>? get customLocations => config?.customLocations;

  @override
  List<Object?> get props => [players, canStart, config];
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
  final GameConfig? config;

  const GameSetupSuccess({
    required this.message,
    required this.players,
    required this.canStart,
    this.config,
  });

  @override
  List<Object?> get props => [message, players, canStart, config];
}

/// Game started state - navigate to game
class GameSetupStarted extends GameSetupState {
  final List<Player> players;

  const GameSetupStarted(this.players);

  @override
  List<Object?> get props => [players];
}

