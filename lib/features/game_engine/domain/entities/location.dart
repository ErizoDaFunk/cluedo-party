import 'package:equatable/equatable.dart';

/// Location entity - represents a place/room where the murder can happen
class Location extends Equatable {
  final String id;
  final String name;
  final bool isCustom; // true if user-defined, false if default

  const Location({
    required this.id,
    required this.name,
    this.isCustom = false,
  });

  @override
  List<Object?> get props => [id, name, isCustom];

  @override
  String toString() => 'Location(id: $id, name: $name, isCustom: $isCustom)';
}

