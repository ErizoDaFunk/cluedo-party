import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/room.dart';
import '../../domain/usecases/create_room.dart';
import '../../domain/usecases/join_room.dart';
import '../../domain/usecases/start_game.dart';
import '../../domain/usecases/sync_game_state.dart';
import 'room_event.dart';
import 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final CreateRoomUseCase createRoomUseCase;
  final JoinRoomUseCase joinRoomUseCase;
  final WatchRoomUseCase watchRoomUseCase;
  final StartGameUseCase startGameUseCase;
  
  final _uuid = const Uuid();
  String? _currentPlayerId;
  StreamSubscription<Either<Failure, Room>>? _roomSubscription;

  RoomBloc({
    required this.createRoomUseCase,
    required this.joinRoomUseCase,
    required this.watchRoomUseCase,
    required this.startGameUseCase,
  }) : super(const RoomInitial()) {
    on<CreateRoomEvent>(_onCreateRoom);
    on<JoinRoomEvent>(_onJoinRoom);
    on<WatchRoomEvent>(_onWatchRoom);
    on<RoomDataReceived>(_onRoomDataReceived);
    on<StartGameEvent>(_onStartGame);
    on<LeaveRoomEvent>(_onLeaveRoom);
  }

  Future<void> _onCreateRoom(
    CreateRoomEvent event,
    Emitter<RoomState> emit,
  ) async {
    emit(const RoomLoading());

    _currentPlayerId = _uuid.v4();

    final result = await createRoomUseCase(
      playerName: event.playerName,
      playerId: _currentPlayerId!,
    );

    result.fold(
      (failure) => emit(RoomError(failure.message)),
      (room) {
        emit(RoomCreated(room, _currentPlayerId!));
        // Automatically start watching the room
        add(WatchRoomEvent(room.code));
      },
    );
  }

  Future<void> _onJoinRoom(
    JoinRoomEvent event,
    Emitter<RoomState> emit,
  ) async {
    emit(const RoomLoading());

    _currentPlayerId = _uuid.v4();

    final result = await joinRoomUseCase(
      roomCode: event.roomCode,
      playerName: event.playerName,
      playerId: _currentPlayerId!,
    );

    result.fold(
      (failure) => emit(RoomError(failure.message)),
      (room) {
        emit(RoomJoined(room, _currentPlayerId!));
        // Automatically start watching the room
        add(WatchRoomEvent(room.code));
      },
    );
  }

  Future<void> _onWatchRoom(
    WatchRoomEvent event,
    Emitter<RoomState> emit,
  ) async {
    print('🔵 [RoomBloc] Starting to watch room: ${event.roomCode}');
    await _roomSubscription?.cancel();
    
    _roomSubscription = watchRoomUseCase(event.roomCode).listen(
      (result) {
        print('🟢 [RoomBloc] Stream emitted data');
        result.fold(
          (failure) {
            print('🔴 [RoomBloc] Error from stream: ${failure.message}');
            if (!isClosed) {
              add(const LeaveRoomEvent());
            }
          },
          (room) {
            print('🟢 [RoomBloc] Got room data, adding internal event');
            if (!isClosed) {
              add(RoomDataReceived(room));
            }
          },
        );
      },
      onError: (error) {
        print('🔴 [RoomBloc] Stream error: $error');
      },
    );
  }

  Future<void> _onRoomDataReceived(
    RoomDataReceived event,
    Emitter<RoomState> emit,
  ) async {
    final room = event.room;
    print('🟢 [RoomBloc] Processing room data - Players: ${room.players.length}, Status: ${room.status}');
    room.players.forEach((id, player) {
      print('  👤 Player: ${player.name} (${player.isHost ? "HOST" : "member"})');
    });
    
    if (_currentPlayerId != null) {
      print('🟢 [RoomBloc] Emitting RoomUpdated state');
      emit(RoomUpdated(room, _currentPlayerId!));
    } else {
      print('⚠️ [RoomBloc] No current player ID');
    }
  }

  Future<void> _onStartGame(
    StartGameEvent event,
    Emitter<RoomState> emit,
  ) async {
    final result = await startGameUseCase(event.roomCode);

    result.fold(
      (failure) => emit(RoomError(failure.message)),
      (_) {}, // Room will be updated via the watch stream
    );
  }

  Future<void> _onLeaveRoom(
    LeaveRoomEvent event,
    Emitter<RoomState> emit,
  ) async {
    await _roomSubscription?.cancel();
    _roomSubscription = null;
    _currentPlayerId = null;
    emit(const RoomInitial());
  }

  @override
  Future<void> close() {
    _roomSubscription?.cancel();
    return super.close();
  }
}
