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

/// Event to toggle weapon requirement
class ToggleWeaponRequirement extends GameSetupEvent {
  final bool requireWeapon;

  const ToggleWeaponRequirement(this.requireWeapon);

  @override
  List<Object?> get props => [requireWeapon];
}

/// Event to toggle location requirement
class ToggleLocationRequirement extends GameSetupEvent {
  final bool requireLocation;

  const ToggleLocationRequirement(this.requireLocation);

  @override
  List<Object?> get props => [requireLocation];
}

/// Event to update custom weapons
class UpdateCustomWeapons extends GameSetupEvent {
  final List<String> weapons;

  const UpdateCustomWeapons(this.weapons);

  @override
  List<Object?> get props => [weapons];
}

/// Event to update custom locations
class UpdateCustomLocations extends GameSetupEvent {
  final List<String> locations;

  const UpdateCustomLocations(this.locations);

  @override
  List<Object?> get props => [locations];
}

/// Event to start the game
class StartGameEvent extends GameSetupEvent {
  const StartGameEvent();
}

/// Event to reset/clear the game setup
class ResetGameSetup extends GameSetupEvent {
  const ResetGameSetup();
}

