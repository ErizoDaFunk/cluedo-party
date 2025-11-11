import 'package:equatable/equatable.dart';
import 'player.dart';

/// Game configuration entity - holds setup data before game starts
class GameConfig extends Equatable {
  final List<Player> players;
  final DateTime createdAt;

  const GameConfig({
    required this.players,
    required this.createdAt,
  });

  /// Check if game can be started (minimum players)
  bool get canStart => players.length >= 3;

  /// Get number of players
  int get playerCount => players.length;

  /// Check if a player name already exists
  bool hasPlayer(String name) {
    return players.any((p) => p.name.toLowerCase() == name.toLowerCase());
  }

  /// Add a player
  GameConfig addPlayer(Player player) {
    return GameConfig(
      players: [...players, player],
      createdAt: createdAt,
    );
  }

  /// Remove a player by id
  GameConfig removePlayer(String playerId) {
    return GameConfig(
      players: players.where((p) => p.id != playerId).toList(),
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [players, createdAt];

  @override
  String toString() => 'GameConfig(players: ${players.length}, createdAt: $createdAt)';
}

