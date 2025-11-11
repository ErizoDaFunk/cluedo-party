import 'package:equatable/equatable.dart';

/// Player entity - represents a participant in the game
class Player extends Equatable {
  final String id;
  final String name;
  final bool isRevealed; // Has this player seen their assignment?

  const Player({
    required this.id,
    required this.name,
    this.isRevealed = false,
  });

  /// Create a copy with modified fields
  Player copyWith({
    String? id,
    String? name,
    bool? isRevealed,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      isRevealed: isRevealed ?? this.isRevealed,
    );
  }

  @override
  List<Object?> get props => [id, name, isRevealed];

  @override
  String toString() => 'Player(id: $id, name: $name, isRevealed: $isRevealed)';
}

