import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/config/routes.dart';
import 'core/config/theme.dart';
import 'core/constants/game_constants.dart';
import 'core/di/injection.dart';
import 'features/game_data/data/models/location_model.dart';
import 'features/game_data/data/models/weapon_model.dart';
import 'features/game_engine/data/models/assignment_model.dart';
import 'features/game_engine/data/models/game_model.dart';
import 'features/game_setup/data/models/game_config_model.dart';
import 'features/game_setup/data/models/player_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(WeaponModelAdapter());        // typeId: 0
  Hive.registerAdapter(LocationModelAdapter());      // typeId: 1
  Hive.registerAdapter(PlayerModelAdapter());        // typeId: 2
  Hive.registerAdapter(GameConfigModelAdapter());    // typeId: 3
  Hive.registerAdapter(AssignmentModelAdapter());    // typeId: 4
  Hive.registerAdapter(GameModelAdapter());          // typeId: 5
  
  // Setup dependency injection
  await setupDependencies();
  
  runApp(const CluedoPartyApp());
}

class CluedoPartyApp extends StatelessWidget {
  const CluedoPartyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: GameConstants.appTitle,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
    );
  }
}

