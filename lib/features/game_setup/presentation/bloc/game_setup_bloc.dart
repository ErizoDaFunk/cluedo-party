import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/game_constants.dart';
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
  final _uuid = const Uuid();

  GameSetupBloc({
    required this.repository,
    required this.addPlayerUseCase,
    required this.removePlayerUseCase,
    required this.validateGameConfigUseCase,
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
        final players = config?.players ?? [];
        final canStart = config?.canStart ?? false;
        emit(GameSetupLoaded(
          players: players,
          canStart: canStart,
          config: config,
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

        // Validate configuration
        final validationResult = await validateGameConfigUseCase(config);
        
        validationResult.fold(
          (failure) => emit(GameSetupError(failure.message)),
          (isValid) {
            if (isValid) {
              emit(GameSetupStarted(config.players));
            } else {
              emit(const GameSetupError(GameConstants.errorNotEnoughPlayers));
            }
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

        final updatedConfig = config.toggleWeaponRequirement(event.requireWeapon);
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

        final updatedConfig = config.toggleLocationRequirement(event.requireLocation);
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

