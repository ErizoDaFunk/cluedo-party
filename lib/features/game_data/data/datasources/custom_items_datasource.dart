import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/game_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/weapon_model.dart';
import '../models/location_model.dart';

/// Data source for custom (user-defined) weapons and locations
/// Uses Hive for local storage
class CustomItemsDataSource {
  final _uuid = const Uuid();
  Box<WeaponModel>? _weaponsBox;
  Box<LocationModel>? _locationsBox;

  /// Initialize Hive boxes
  Future<void> init() async {
    try {
      _weaponsBox = await Hive.openBox<WeaponModel>(GameConstants.customWeaponsKey);
      _locationsBox = await Hive.openBox<LocationModel>(GameConstants.customLocationsKey);
    } catch (e) {
      throw CacheException('Error initializing custom items storage: $e');
    }
  }

  /// Get all custom weapons
  Future<List<WeaponModel>> getCustomWeapons() async {
    try {
      if (_weaponsBox == null) await init();
      return _weaponsBox!.values.toList();
    } catch (e) {
      throw CacheException('Error loading custom weapons: $e');
    }
  }

  /// Get all custom locations
  Future<List<LocationModel>> getCustomLocations() async {
    try {
      if (_locationsBox == null) await init();
      return _locationsBox!.values.toList();
    } catch (e) {
      throw CacheException('Error loading custom locations: $e');
    }
  }

  /// Add a custom weapon
  Future<void> addCustomWeapon(String name) async {
    try {
      if (_weaponsBox == null) await init();
      
      final weapon = WeaponModel(
        id: _uuid.v4(),
        name: name,
        isCustom: true,
      );
      
      await _weaponsBox!.put(weapon.id, weapon);
    } catch (e) {
      throw CacheException('Error adding custom weapon: $e');
    }
  }

  /// Add a custom location
  Future<void> addCustomLocation(String name) async {
    try {
      if (_locationsBox == null) await init();
      
      final location = LocationModel(
        id: _uuid.v4(),
        name: name,
        isCustom: true,
      );
      
      await _locationsBox!.put(location.id, location);
    } catch (e) {
      throw CacheException('Error adding custom location: $e');
    }
  }

  /// Remove a custom weapon
  Future<void> removeCustomWeapon(String id) async {
    try {
      if (_weaponsBox == null) await init();
      await _weaponsBox!.delete(id);
    } catch (e) {
      throw CacheException('Error removing custom weapon: $e');
    }
  }

  /// Remove a custom location
  Future<void> removeCustomLocation(String id) async {
    try {
      if (_locationsBox == null) await init();
      await _locationsBox!.delete(id);
    } catch (e) {
      throw CacheException('Error removing custom location: $e');
    }
  }

  /// Clear all custom weapons
  Future<void> clearCustomWeapons() async {
    try {
      if (_weaponsBox == null) await init();
      await _weaponsBox!.clear();
    } catch (e) {
      throw CacheException('Error clearing custom weapons: $e');
    }
  }

  /// Clear all custom locations
  Future<void> clearCustomLocations() async {
    try {
      if (_locationsBox == null) await init();
      await _locationsBox!.clear();
    } catch (e) {
      throw CacheException('Error clearing custom locations: $e');
    }
  }
}

