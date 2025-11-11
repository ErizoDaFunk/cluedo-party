import 'package:hive/hive.dart';
import '../../../game_engine/domain/entities/weapon.dart';

part 'weapon_model.g.dart';

@HiveType(typeId: 0)
class WeaponModel extends Weapon {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String name;

  @HiveField(2)
  @override
  final bool isCustom;

  const WeaponModel({
    required this.id,
    required this.name,
    required this.isCustom,
  }) : super(id: id, name: name, isCustom: isCustom);

  /// Create from entity
  factory WeaponModel.fromEntity(Weapon weapon) {
    return WeaponModel(
      id: weapon.id,
      name: weapon.name,
      isCustom: weapon.isCustom,
    );
  }

  /// Create from JSON
  factory WeaponModel.fromJson(Map<String, dynamic> json) {
    return WeaponModel(
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
  WeaponModel copyWith({
    String? id,
    String? name,
    bool? isCustom,
  }) {
    return WeaponModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}

