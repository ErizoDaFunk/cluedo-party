import 'package:uuid/uuid.dart';
import '../../../../core/constants/game_constants.dart';
import '../models/weapon_model.dart';
import '../models/location_model.dart';

/// Data source for default (hardcoded) weapons and locations
class DefaultItemsDataSource {
  final _uuid = const Uuid();

  /// Get all default weapons
  List<WeaponModel> getDefaultWeapons() {
    return GameConstants.defaultWeapons
        .map((name) => WeaponModel(
              id: _uuid.v4(),
              name: name,
              isCustom: false,
            ))
        .toList();
  }

  /// Get all default locations
  List<LocationModel> getDefaultLocations() {
    return GameConstants.defaultLocations
        .map((name) => LocationModel(
              id: _uuid.v4(),
              name: name,
              isCustom: false,
            ))
        .toList();
  }
}

