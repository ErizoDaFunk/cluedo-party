import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/game_constants.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../game_engine/domain/entities/game.dart';
import '../../../game_engine/domain/usecases/generate_assignments.dart';
import '../../domain/entities/game_config.dart';
import '../../domain/entities/player.dart';
import '../../domain/repositories/game_setup_repository.dart';
import '../../domain/usecases/add_player.dart';
import '../../domain/usecases/remove_player.dart';
import '../../domain/usecases/validate_game_config.dart';
import 'game_setup_event.dart';
import 'game_setup_state.dart';

/// BLoC for managing game setup
class GameSetupBloc extends Bloc<GameSetupEvent, GameSetupState> {
  final GameSetupRepository repository;
  final AddPlayer addPlayerUseCase;
  final RemovePlayer removePlayerUseCase;
  final ValidateGameConfig validateGameConfigUseCase;
  final GenerateAssignments generateAssignments;
  final _uuid = const Uuid();

  GameSetupBloc({
    required this.repository,
    required this.addPlayerUseCase,
    required this.removePlayerUseCase,
    required this.validateGameConfigUseCase,
    required this.generateAssignments,
  }) : super(const GameSetupInitial()) {
    on<LoadGameSetup>(_onLoadGameSetup);
    on<AddPlayerEvent>(_onAddPlayer);
    on<RemovePlayerEvent>(_onRemovePlayer);
    on<ToggleWeaponRequirement>(_onToggleWeaponRequirement);
    on<ToggleLocationRequirement>(_onToggleLocationRequirement);
    on<UpdateCustomWeapons>(_onUpdateCustomWeapons);
    on<UpdateCustomLocations>(_onUpdateCustomLocations);
    on<StartGameEvent>(_onStartGame);
    on<ResetGameSetup>(_onResetGameSetup);
  }

  Future<void> _onLoadGameSetup(
    LoadGameSetup event,
    Emitter<GameSetupState> emit,
  ) async {
    emit(const GameSetupLoading());

    final result = await repository.getCurrentConfig();

    result.fold(
      (failure) => emit(GameSetupError(failure.message)),
      (config) {
        AppLogger.info('GameSetupBloc', 'Loading config...');
        AppLogger.debug('GameSetupBloc', 'Config is null: ${config == null}');
        if (config != null) {
          AppLogger.debug('GameSetupBloc', 'Config requireWeapon: ${config.requireWeapon}');
          AppLogger.debug('GameSetupBloc', 'Config requireLocation: ${config.requireLocation}');
          AppLogger.debug('GameSetupBloc', 'Config customWeapons null: ${config.customWeapons == null}');
          AppLogger.debug('GameSetupBloc', 'Config customWeapons length: ${config.customWeapons?.length ?? 0}');
          AppLogger.debug('GameSetupBloc', 'Config customLocations null: ${config.customLocations == null}');
          AppLogger.debug('GameSetupBloc', 'Config customLocations length: ${config.customLocations?.length ?? 0}');
        }
        
        // If config exists but weapons/locations are missing, initialize them
        GameConfig? finalConfig = config;
        if (config != null) {
          var needsUpdate = false;
          var updatedConfig = config;
          
          // Initialize weapons if required but empty
          if (config.requireWeapon && (config.customWeapons == null || config.customWeapons!.isEmpty)) {
            AppLogger.warning('GameSetupBloc', 'Initializing weapons with defaults');
            updatedConfig = updatedConfig.updateWeapons(GameConstants.defaultWeapons.toList());
            needsUpdate = true;
          }
          
          // Initialize locations if required but empty
          if (config.requireLocation && (config.customLocations == null || config.customLocations!.isEmpty)) {
            AppLogger.warning('GameSetupBloc', 'Initializing locations with defaults');
            updatedConfig = updatedConfig.updateLocations(GameConstants.defaultLocations.toList());
            needsUpdate = true;
          }
          
          if (needsUpdate) {
            AppLogger.info('GameSetupBloc', 'Saving updated config with initialized weapons/locations');
            repository.saveConfig(updatedConfig);
            finalConfig = updatedConfig;
          }
        }
        
        final players = finalConfig?.players ?? [];
        final canStart = finalConfig?.canStart ?? false;
        emit(GameSetupLoaded(
          players: players,
          canStart: canStart,
          config: finalConfig,
        ));
      },
    );
  }

  Future<void> _onAddPlayer(
    AddPlayerEvent event,
    Emitter<GameSetupState> emit,
  ) async {
    final currentState = state;
    if (currentState is! GameSetupLoaded && currentState is! GameSetupSuccess) {
      return;
    }

    final player = Player(
      id: _uuid.v4(),
      name: event.playerName,
    );

    final result = await addPlayerUseCase(player);

    await result.fold(
      (failure) async => emit(GameSetupError(failure.message)),
      (_) async {
        // Reload config to get updated list
        final configResult = await repository.getCurrentConfig();
        configResult.fold(
          (failure) => emit(GameSetupError(failure.message)),
          (config) {
            final players = config?.players ?? [];
            final canStart = config?.canStart ?? false;
            emit(GameSetupSuccess(
              message: GameConstants.successPlayerAdded,
              players: players,
              canStart: canStart,
              config: config,
            ));
          },
        );
      },
    );
  }

  Future<void> _onRemovePlayer(
    RemovePlayerEvent event,
    Emitter<GameSetupState> emit,
  ) async {
    final result = await removePlayerUseCase(event.playerId);

    await result.fold(
      (failure) async => emit(GameSetupError(failure.message)),
      (_) async {
        // Reload config to get updated list
        final configResult = await repository.getCurrentConfig();
        configResult.fold(
          (failure) => emit(GameSetupError(failure.message)),
          (config) {
            final players = config?.players ?? [];
            final canStart = config?.canStart ?? false;
            emit(GameSetupSuccess(
              message: GameConstants.successPlayerRemoved,
              players: players,
              canStart: canStart,
              config: config,
            ));
          },
        );
      },
    );
  }

  Future<void> _onStartGame(
    StartGameEvent event,
    Emitter<GameSetupState> emit,
  ) async {
    final configResult = await repository.getCurrentConfig();

    await configResult.fold(
      (failure) async => emit(GameSetupError(failure.message)),
      (config) async {
        if (config == null) {
          emit(const GameSetupError(GameConstants.errorNoActiveGame));
          return;
        }

        AppLogger.info('GameSetupBloc', '========== START GAME ==========');
        AppLogger.info('GameSetupBloc', 'Players: ${config.players.length}');
        AppLogger.info('GameSetupBloc', 'Require Weapon: ${config.requireWeapon}');
        AppLogger.info('GameSetupBloc', 'Require Location: ${config.requireLocation}');
        AppLogger.info('GameSetupBloc', 'Custom Weapons: ${config.customWeapons?.length ?? 0}');
        AppLogger.info('GameSetupBloc', 'Custom Locations: ${config.customLocations?.length ?? 0}');
        if (config.customWeapons != null && config.customWeapons!.isNotEmpty) {
          AppLogger.debug('GameSetupBloc', 'Weapons: ${config.customWeapons!.take(3).join(", ")}...');
        }
        if (config.customLocations != null && config.customLocations!.isNotEmpty) {
          AppLogger.debug('GameSetupBloc', 'Locations: ${config.customLocations!.take(3).join(", ")}...');
        }

        // FIX: Initialize weapons/locations if missing
        var fixedConfig = config;
        if (config.requireWeapon && (config.customWeapons == null || config.customWeapons!.isEmpty)) {
          AppLogger.warning('GameSetupBloc', 'FIXING: Initializing weapons with defaults');
          fixedConfig = fixedConfig.updateWeapons(GameConstants.defaultWeapons.toList());
        }
        if (config.requireLocation && (config.customLocations == null || config.customLocations!.isEmpty)) {
          AppLogger.warning('GameSetupBloc', 'FIXING: Initializing locations with defaults');
          fixedConfig = fixedConfig.updateLocations(GameConstants.defaultLocations.toList());
        }
        
        // Save fixed config if it was updated
        if (fixedConfig != config) {
          AppLogger.info('GameSetupBloc', 'Saving fixed config to database');
          await repository.saveConfig(fixedConfig);
        }

        // Validate configuration
        final validationResult = await validateGameConfigUseCase(fixedConfig);
        
        await validationResult.fold(
          (failure) async => emit(GameSetupError(failure.message)),
          (isValid) async {
            if (!isValid) {
              emit(const GameSetupError(GameConstants.errorNotEnoughPlayers));
              return;
            }

            // Generate assignments
            final assignmentsResult = await generateAssignments(fixedConfig);
            
            assignmentsResult.fold(
              (failure) => emit(GameSetupError(failure.message)),
              (assignments) {
                final game = Game(
                  id: _uuid.v4(),
                  assignments: assignments,
                  createdAt: DateTime.now(),
                );
                
                emit(GameSetupStarted(
                  game: game,
                  players: fixedConfig.players,
                  weapons: fixedConfig.customWeapons,
                  locations: fixedConfig.customLocations,
                ));
              },
            );
          },
        );
      },
    );
  }

  Future<void> _onResetGameSetup(
    ResetGameSetup event,
    Emitter<GameSetupState> emit,
  ) async {
    emit(const GameSetupLoading());

    final result = await repository.clearConfig();

    result.fold(
      (failure) => emit(GameSetupError(failure.message)),
      (_) => emit(const GameSetupLoaded(players: [], canStart: false)),
    );
  }

  Future<void> _onToggleWeaponRequirement(
    ToggleWeaponRequirement event,
    Emitter<GameSetupState> emit,
  ) async {
    final configResult = await repository.getCurrentConfig();

    await configResult.fold(
      (failure) async => emit(GameSetupError(failure.message)),
      (config) async {
        if (config == null) return;

        var updatedConfig = config.toggleWeaponRequirement(event.requireWeapon);
        
        // Initialize with default weapons if enabling requirement and no weapons set
        if (event.requireWeapon && (updatedConfig.customWeapons == null || updatedConfig.customWeapons!.isEmpty)) {
          updatedConfig = updatedConfig.updateWeapons(GameConstants.defaultWeapons.toList());
        }
        
        final saveResult = await repository.saveConfig(updatedConfig);

        saveResult.fold(
          (failure) => emit(GameSetupError(failure.message)),
          (_) {
            emit(GameSetupLoaded(
              players: updatedConfig.players,
              canStart: updatedConfig.canStart,
              config: updatedConfig,
            ));
          },
        );
      },
    );
  }

  Future<void> _onToggleLocationRequirement(
    ToggleLocationRequirement event,
    Emitter<GameSetupState> emit,
  ) async {
    final configResult = await repository.getCurrentConfig();

    await configResult.fold(
      (failure) async => emit(GameSetupError(failure.message)),
      (config) async {
        if (config == null) return;

        var updatedConfig = config.toggleLocationRequirement(event.requireLocation);
        
        // Initialize with default locations if enabling requirement and no locations set
        if (event.requireLocation && (updatedConfig.customLocations == null || updatedConfig.customLocations!.isEmpty)) {
          updatedConfig = updatedConfig.updateLocations(GameConstants.defaultLocations.toList());
        }
        
        final saveResult = await repository.saveConfig(updatedConfig);

        saveResult.fold(
          (failure) => emit(GameSetupError(failure.message)),
          (_) {
            emit(GameSetupLoaded(
              players: updatedConfig.players,
              canStart: updatedConfig.canStart,
              config: updatedConfig,
            ));
          },
        );
      },
    );
  }

  Future<void> _onUpdateCustomWeapons(
    UpdateCustomWeapons event,
    Emitter<GameSetupState> emit,
  ) async {
    final configResult = await repository.getCurrentConfig();

    await configResult.fold(
      (failure) async => emit(GameSetupError(failure.message)),
      (config) async {
        if (config == null) return;

        final updatedConfig = config.updateWeapons(event.weapons);
        final saveResult = await repository.saveConfig(updatedConfig);

        saveResult.fold(
          (failure) => emit(GameSetupError(failure.message)),
          (_) {
            emit(GameSetupLoaded(
              players: updatedConfig.players,
              canStart: updatedConfig.canStart,
              config: updatedConfig,
            ));
          },
        );
      },
    );
  }

  Future<void> _onUpdateCustomLocations(
    UpdateCustomLocations event,
    Emitter<GameSetupState> emit,
  ) async {
    final configResult = await repository.getCurrentConfig();

    await configResult.fold(
      (failure) async => emit(GameSetupError(failure.message)),
      (config) async {
        if (config == null) return;

        final updatedConfig = config.updateLocations(event.locations);
        final saveResult = await repository.saveConfig(updatedConfig);

        saveResult.fold(
          (failure) => emit(GameSetupError(failure.message)),
          (_) {
            emit(GameSetupLoaded(
              players: updatedConfig.players,
              canStart: updatedConfig.canStart,
              config: updatedConfig,
            ));
          },
        );
      },
    );
  }
}

