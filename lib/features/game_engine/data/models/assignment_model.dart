import 'package:hive/hive.dart';
import '../../domain/entities/assignment.dart';

part 'assignment_model.g.dart';

@HiveType(typeId: 4)
class AssignmentModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String killerId;

  @HiveField(2)
  final String victimId;

  @HiveField(3)
  final String? weaponId;

  @HiveField(4)
  final String? locationId;

  @HiveField(5)
  final bool isRevealed;

  AssignmentModel({
    required this.id,
    required this.killerId,
    required this.victimId,
    this.weaponId,
    this.locationId,
    this.isRevealed = false,
  });

  /// Convert from domain entity
  factory AssignmentModel.fromEntity(Assignment assignment) {
    return AssignmentModel(
      id: assignment.id,
      killerId: assignment.killerId,
      victimId: assignment.victimId,
      weaponId: assignment.weaponId,
      locationId: assignment.locationId,
      isRevealed: assignment.isRevealed,
    );
  }

  /// Convert to domain entity
  Assignment toEntity() {
    return Assignment(
      id: id,
      killerId: killerId,
      victimId: victimId,
      weaponId: weaponId,
      locationId: locationId,
      isRevealed: isRevealed,
    );
  }

  /// Create from JSON
  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] as String,
      killerId: json['killerId'] as String,
      victimId: json['victimId'] as String,
      weaponId: json['weaponId'] as String?,
      locationId: json['locationId'] as String?,
      isRevealed: json['isRevealed'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'killerId': killerId,
      'victimId': victimId,
      'weaponId': weaponId,
      'locationId': locationId,
      'isRevealed': isRevealed,
    };
  }
}
