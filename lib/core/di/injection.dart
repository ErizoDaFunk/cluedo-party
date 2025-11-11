import 'package:get_it/get_it.dart';
import '../../features/game_data/data/datasources/custom_items_datasource.dart';
import '../../features/game_data/data/datasources/default_items_datasource.dart';
import '../../features/game_data/data/repositories/items_repository_impl.dart';
import '../../features/game_data/domain/repositories/items_repository.dart';
import '../../../features/game_data/domain/usecases/get_locations.dart';
import '../../../features/game_data/domain/usecases/get_weapons.dart';
import '../../../features/game_engine/domain/usecases/generate_assignments.dart';
import '../../../features/game_setup/data/datasources/local_game_datasource.dart';
import '../../features/game_setup/data/repositories/game_setup_repository_impl.dart';
import '../../features/game_setup/domain/repositories/game_setup_repository.dart';
import '../../features/game_setup/domain/usecases/add_player.dart';
import '../../features/game_setup/domain/usecases/remove_player.dart';
import '../../features/game_setup/domain/usecases/validate_game_config.dart';
import '../../features/game_setup/presentation/bloc/game_setup_bloc.dart';

final getIt = GetIt.instance;

/// Setup all dependencies for the app
Future<void> setupDependencies() async {
  // ============================================
  // DATA SOURCES
  // ============================================
  
  // Game Data
  getIt.registerLazySingleton<DefaultItemsDataSource>(
    () => DefaultItemsDataSource(),
  );
  
  getIt.registerLazySingleton<CustomItemsDataSource>(
    () => CustomItemsDataSource(),
  );
  
  // Game Setup
  getIt.registerLazySingleton<LocalGameDataSource>(
    () => LocalGameDataSource(),
  );

  // ============================================
  // REPOSITORIES
  // ============================================
  
  // Game Data Repository
  getIt.registerLazySingleton<ItemsRepository>(
    () => ItemsRepositoryImpl(
      defaultDataSource: getIt<DefaultItemsDataSource>(),
      customDataSource: getIt<CustomItemsDataSource>(),
    ),
  );
  
  // Game Setup Repository
  getIt.registerLazySingleton<GameSetupRepository>(
    () => GameSetupRepositoryImpl(
      localDataSource: getIt<LocalGameDataSource>(),
    ),
  );

  // ============================================
  // USE CASES
  // ============================================
  
  // Game Data Use Cases
  getIt.registerLazySingleton(() => GetWeapons(getIt<ItemsRepository>()));
  getIt.registerLazySingleton(() => GetLocations(getIt<ItemsRepository>()));
  
  // Game Setup Use Cases
  getIt.registerLazySingleton(() => AddPlayer(getIt<GameSetupRepository>()));
  getIt.registerLazySingleton(() => RemovePlayer(getIt<GameSetupRepository>()));
  getIt.registerLazySingleton(() => ValidateGameConfig(getIt<GameSetupRepository>()));
  
  // Game Engine Use Cases
  getIt.registerLazySingleton(() => GenerateAssignments());

  // ============================================
  // BLoCs (Factories - new instance each time)
  // ============================================
  
  getIt.registerFactory(
    () => GameSetupBloc(
      repository: getIt<GameSetupRepository>(),
      addPlayerUseCase: getIt<AddPlayer>(),
      removePlayerUseCase: getIt<RemovePlayer>(),
      validateGameConfigUseCase: getIt<ValidateGameConfig>(),
      generateAssignments: getIt<GenerateAssignments>(),
    ),
  );
}
