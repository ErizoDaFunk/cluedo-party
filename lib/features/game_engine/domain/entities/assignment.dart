import 'package:equatable/equatable.dart';

/// Represents a player's assassination assignment in the game
/// 
/// Each assignment contains:
/// - killerId: The player who must perform the assassination
/// - victimId: The target player to be eliminated
/// - weaponId: Optional weapon requirement (if game rules require it)
/// - locationId: Optional location requirement (if game rules require it)
/// - isRevealed: Whether this assignment has been shown to the killer
class Assignment extends Equatable {
  final String id;
  final String killerId;
  final String victimId;
  final String? weaponId;
  final String? locationId;
  final bool isRevealed;

  const Assignment({
    required this.id,
    required this.killerId,
    required this.victimId,
    this.weaponId,
    this.locationId,
    this.isRevealed = false,
  });

  /// Mark this assignment as revealed to the player
  Assignment reveal() {
    return Assignment(
      id: id,
      killerId: killerId,
      victimId: victimId,
      weaponId: weaponId,
      locationId: locationId,
      isRevealed: true,
    );
  }

  /// Create a copy with modified fields
  Assignment copyWith({
    String? id,
    String? killerId,
    String? victimId,
    String? weaponId,
    String? locationId,
    bool? isRevealed,
  }) {
    return Assignment(
      id: id ?? this.id,
      killerId: killerId ?? this.killerId,
      victimId: victimId ?? this.victimId,
      weaponId: weaponId ?? this.weaponId,
      locationId: locationId ?? this.locationId,
      isRevealed: isRevealed ?? this.isRevealed,
    );
  }

  @override
  List<Object?> get props => [
        id,
        killerId,
        victimId,
        weaponId,
        locationId,
        isRevealed,
      ];
}
