import 'package:equatable/equatable.dart';

/// Weapon entity - represents a weapon/object used in the game
class Weapon extends Equatable {
  final String id;
  final String name;
  final bool isCustom; // true if user-defined, false if default

  const Weapon({
    required this.id,
    required this.name,
    this.isCustom = false,
  });

  @override
  List<Object?> get props => [id, name, isCustom];

  @override
  String toString() => 'Weapon(id: $id, name: $name, isCustom: $isCustom)';
}

