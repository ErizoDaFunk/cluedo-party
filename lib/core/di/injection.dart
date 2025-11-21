import 'package:cloud_firestore/cloud_firestore.dart';
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
import '../../features/multiplayer/data/datasources/firebase_room_datasource.dart';
import '../../features/multiplayer/data/repositories/room_repository_impl.dart';
import '../../features/multiplayer/domain/repositories/room_repository.dart';
import '../../features/multiplayer/domain/usecases/create_room.dart';
import '../../features/multiplayer/domain/usecases/join_room.dart';
import '../../features/multiplayer/domain/usecases/start_game.dart';
import '../../features/multiplayer/domain/usecases/update_game_settings.dart';
import '../../features/multiplayer/domain/usecases/report_kill.dart';
import '../../features/multiplayer/domain/usecases/sync_game_state.dart';
import '../../features/multiplayer/presentation/bloc/room_bloc.dart';

final getIt = GetIt.instance;

/// Setup all dependencies for the app
Future<void> setupDependencies() async {
  // ============================================
  // EXTERNAL
  // ============================================
  
  // Firebase Firestore
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);

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

  // Multiplayer
  getIt.registerLazySingleton<FirebaseRoomDataSource>(
    () => FirebaseRoomDataSourceImpl(
      firestore: getIt<FirebaseFirestore>(),
    ),
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

  // Multiplayer Repository
  getIt.registerLazySingleton<RoomRepository>(
    () => RoomRepositoryImpl(
      dataSource: getIt<FirebaseRoomDataSource>(),
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

  // Multiplayer Use Cases
  getIt.registerLazySingleton(() => CreateRoomUseCase(getIt<RoomRepository>()));
  getIt.registerLazySingleton(() => JoinRoomUseCase(getIt<RoomRepository>()));
  getIt.registerLazySingleton(() => WatchRoomUseCase(getIt<RoomRepository>()));
  getIt.registerLazySingleton(() => StartGameUseCase(getIt<RoomRepository>()));
  getIt.registerLazySingleton(() => UpdateGameSettingsUseCase(getIt<RoomRepository>()));
  getIt.registerLazySingleton(() => ReportKillUseCase(getIt<RoomRepository>()));

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

  getIt.registerFactory(
    () => RoomBloc(
      createRoomUseCase: getIt<CreateRoomUseCase>(),
      joinRoomUseCase: getIt<JoinRoomUseCase>(),
      startGameUseCase: getIt<StartGameUseCase>(),
    ),
  );
}
