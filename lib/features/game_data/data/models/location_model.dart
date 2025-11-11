import 'package:hive/hive.dart';
import '../../../game_engine/domain/entities/location.dart';

part 'location_model.g.dart';

@HiveType(typeId: 1)
class LocationModel extends Location {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String name;

  @HiveField(2)
  @override
  final bool isCustom;

  const LocationModel({
    required this.id,
    required this.name,
    required this.isCustom,
  }) : super(id: id, name: name, isCustom: isCustom);

  /// Create from entity
  factory LocationModel.fromEntity(Location location) {
    return LocationModel(
      id: location.id,
      name: location.name,
      isCustom: location.isCustom,
    );
  }

  /// Create from JSON
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      isCustom: json['isCustom'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isCustom': isCustom,
    };
  }

  /// Create a copy with modified fields
  LocationModel copyWith({
    String? id,
    String? name,
    bool? isCustom,
  }) {
    return LocationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}

