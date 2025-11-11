import 'package:equatable/equatable.dart';

/// Base class for GameSetup events
abstract class GameSetupEvent extends Equatable {
  const GameSetupEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load current game configuration
class LoadGameSetup extends GameSetupEvent {
  const LoadGameSetup();
}

/// Event to add a new player
class AddPlayerEvent extends GameSetupEvent {
  final String playerName;

  const AddPlayerEvent(this.playerName);

  @override
  List<Object?> get props => [playerName];
}

/// Event to remove a player
class RemovePlayerEvent extends GameSetupEvent {
  final String playerId;

  const RemovePlayerEvent(this.playerId);

  @override
  List<Object?> get props => [playerId];
}

/// Event to start the game
class StartGameEvent extends GameSetupEvent {
  const StartGameEvent();
}

/// Event to reset/clear the game setup
class ResetGameSetup extends GameSetupEvent {
  const ResetGameSetup();
}

