import 'dart:math';
import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../game_setup/domain/entities/game_config.dart';
import '../../../game_setup/domain/entities/player.dart';
import '../entities/assignment.dart';

/// Use case to generate circular killer-victim assignments
/// 
/// Algorithm:
/// 1. Shuffle players to create random order
/// 2. Create circular chain: player[i] kills player[i+1], last kills first
/// 3. Distribute weapons/locations according to rules:
///    - If fewer items than players: each item used at least once, some repeat
///    - If more items than players: random selection, no repeats
class GenerateAssignments {
  final _uuid = const Uuid();
  final _random = Random();

  /// Generate assignments from game configuration
  /// 
  /// Returns Either<Failure, List<Assignment>>
  Future<Either<Failure, List<Assignment>>> call(GameConfig config) async {
    try {
      if (config.players.length < 3) {
        return Left(ValidationFailure('At least 3 players required'));
      }

      // Shuffle players for randomization
      final shuffledPlayers = List<Player>.from(config.players)..shuffle(_random);

      // Generate circular killer-victim pairs
      final assignments = <Assignment>[];
      for (int i = 0; i < shuffledPlayers.length; i++) {
        final killer = shuffledPlayers[i];
        final victim = shuffledPlayers[(i + 1) % shuffledPlayers.length];

        assignments.add(Assignment(
          id: _uuid.v4(),
          killerId: killer.id,
          victimId: victim.id,
        ));
      }

      // Distribute weapons if required
      if (config.requireWeapon) {
        AppLogger.info('GenerateAssignments', 'Processing weapons distribution');
        AppLogger.debug('GenerateAssignments', 'customWeapons is null: ${config.customWeapons == null}');
        AppLogger.debug('GenerateAssignments', 'customWeapons length: ${config.customWeapons?.length ?? 0}');
        
        final List<String> weapons = (config.customWeapons != null && config.customWeapons!.isNotEmpty)
            ? List<String>.from(config.customWeapons!)
            : [];
        
        AppLogger.debug('GenerateAssignments', 'Weapons to distribute: ${weapons.length}');
        
        if (weapons.isEmpty) {
          AppLogger.error('GenerateAssignments', 'ERROR: No weapons available!');
          return Left(ValidationFailure('No weapons available'));
        }
        _distributeItems(assignments, weapons, isWeapon: true);
      }

      // Distribute locations if required
      if (config.requireLocation) {
        AppLogger.info('GenerateAssignments', 'Processing locations distribution');
        AppLogger.debug('GenerateAssignments', 'customLocations is null: ${config.customLocations == null}');
        AppLogger.debug('GenerateAssignments', 'customLocations length: ${config.customLocations?.length ?? 0}');
        
        final List<String> locations = (config.customLocations != null && config.customLocations!.isNotEmpty)
            ? List<String>.from(config.customLocations!)
            : [];
        
        AppLogger.debug('GenerateAssignments', 'Locations to distribute: ${locations.length}');
        
        if (locations.isEmpty) {
          AppLogger.error('GenerateAssignments', 'ERROR: No locations available!');
          return Left(ValidationFailure('No locations available'));
        }
        _distributeItems(assignments, locations, isWeapon: false);
      }

      return Right(assignments);
    } catch (e) {
      return Left(ServerFailure('Failed to generate assignments: $e'));
    }
  }

  /// Distribute items (weapons or locations) to assignments
  /// 
  /// Rules:
  /// - If fewer items than players: each item used at least once, remainder repeats
  /// - If more items than players: random selection without repetition
  void _distributeItems(
    List<Assignment> assignments,
    List<String> items, {
    required bool isWeapon,
  }) {
    final playerCount = assignments.length;
    final itemCount = items.length;

    List<String> distributedItems;

    if (itemCount < playerCount) {
      // Fewer items than players: ensure each item used at least once
      distributedItems = List<String>.from(items);
      
      // Add random items to fill remaining slots
      while (distributedItems.length < playerCount) {
        distributedItems.add(items[_random.nextInt(itemCount)]);
      }
      
      // Shuffle to randomize which assignments get duplicates
      distributedItems.shuffle(_random);
    } else {
      // More items than players: random selection without repeats
      final shuffledItems = List<String>.from(items)..shuffle(_random);
      distributedItems = shuffledItems.take(playerCount).toList();
    }

    // Assign items to assignments
    for (int i = 0; i < assignments.length; i++) {
      if (isWeapon) {
        assignments[i] = assignments[i].copyWith(weaponId: distributedItems[i]);
      } else {
        assignments[i] = assignments[i].copyWith(locationId: distributedItems[i]);
      }
    }
  }
}
