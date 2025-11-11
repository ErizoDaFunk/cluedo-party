import 'package:equatable/equatable.dart';
import 'player.dart';

/// Game configuration entity - holds setup data before game starts
class GameConfig extends Equatable {
  final List<Player> players;
  final DateTime createdAt;
  final bool requireWeapon;
  final bool requireLocation;
  final List<String>? customWeapons;
  final List<String>? customLocations;

  const GameConfig({
    required this.players,
    required this.createdAt,
    this.requireWeapon = true,
    this.requireLocation = true,
    this.customWeapons,
    this.customLocations,
  });

  /// Check if game can be started (minimum players and required configurations)
  bool get canStart {
    if (players.length < 3) return false;
    if (requireWeapon && (customWeapons?.isEmpty ?? false)) return false;
    if (requireLocation && (customLocations?.isEmpty ?? false)) return false;
    return true;
  }

  /// Get number of players
  int get playerCount => players.length;

  /// Check if a player name already exists
  bool hasPlayer(String name) {
    return players.any((p) => p.name.toLowerCase() == name.toLowerCase());
  }

  /// Add a player
  GameConfig addPlayer(Player player) {
    return copyWith(
      players: [...players, player],
    );
  }

  /// Remove a player by id
  GameConfig removePlayer(String playerId) {
    return copyWith(
      players: players.where((p) => p.id != playerId).toList(),
    );
  }

  /// Toggle weapon requirement
  GameConfig toggleWeaponRequirement(bool value) {
    return copyWith(requireWeapon: value);
  }

  /// Toggle location requirement
  GameConfig toggleLocationRequirement(bool value) {
    return copyWith(requireLocation: value);
  }

  /// Update custom weapons
  GameConfig updateWeapons(List<String> weapons) {
    return copyWith(customWeapons: weapons);
  }

  /// Update custom locations
  GameConfig updateLocations(List<String> locations) {
    return copyWith(customLocations: locations);
  }

  /// Copy with method
  GameConfig copyWith({
    List<Player>? players,
    DateTime? createdAt,
    bool? requireWeapon,
    bool? requireLocation,
    List<String>? customWeapons,
    List<String>? customLocations,
  }) {
    return GameConfig(
      players: players ?? this.players,
      createdAt: createdAt ?? this.createdAt,
      requireWeapon: requireWeapon ?? this.requireWeapon,
      requireLocation: requireLocation ?? this.requireLocation,
      customWeapons: customWeapons ?? this.customWeapons,
      customLocations: customLocations ?? this.customLocations,
    );
  }

  @override
  List<Object?> get props => [
        players,
        createdAt,
        requireWeapon,
        requireLocation,
        customWeapons,
        customLocations,
      ];

  @override
  String toString() =>
      'GameConfig(players: ${players.length}, requireWeapon: $requireWeapon, requireLocation: $requireLocation)';
}

