import 'package:hive/hive.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/game_config_model.dart';

/// Local data source for game setup using Hive
class LocalGameDataSource {
  static const String _configKey = 'game_setup_config';
  Box<GameConfigModel>? _box;

  /// Initialize Hive box
  Future<void> init() async {
    try {
      _box = await Hive.openBox<GameConfigModel>('game_setup');
    } catch (e) {
      throw CacheException('Error initializing game setup storage: $e');
    }
  }

  /// Get current game configuration
  Future<GameConfigModel?> getCurrentConfig() async {
    try {
      if (_box == null) await init();
      return _box!.get(_configKey);
    } catch (e) {
      throw CacheException('Error loading game configuration: $e');
    }
  }

  /// Save game configuration
  Future<void> saveConfig(GameConfigModel config) async {
    try {
      if (_box == null) await init();
      await _box!.put(_configKey, config);
    } catch (e) {
      throw CacheException('Error saving game configuration: $e');
    }
  }

  /// Clear game configuration
  Future<void> clearConfig() async {
    try {
      if (_box == null) await init();
      await _box!.delete(_configKey);
    } catch (e) {
      throw CacheException('Error clearing game configuration: $e');
    }
  }
}

