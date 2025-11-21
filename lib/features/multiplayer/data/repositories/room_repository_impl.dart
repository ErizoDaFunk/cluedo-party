import 'dart:math';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/room.dart';
import '../../domain/repositories/room_repository.dart';
import '../datasources/firebase_room_datasource.dart';
import '../models/room_model.dart';

class RoomRepositoryImpl implements RoomRepository {
  final FirebaseRoomDataSource dataSource;

  RoomRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, Room>> createRoom({
    required String playerName,
    required String playerId,
  }) async {
    try {
      // Generate unique room code
      final roomCode = _generateRoomCode();

      // Create host player
      final hostPlayer = RoomPlayerModel(
        id: playerId,
        name: playerName,
        isAlive: true,
        killCount: 0,
        isHost: true,
      );

      // Create room
      final room = RoomModel(
        code: roomCode,
        hostId: playerId,
        status: 'waiting',
        createdAt: DateTime.now(),
        players: {playerId: hostPlayer},
        settings: const GameSettingsModel(), // Default settings
      );

      final result = await dataSource.createRoom(room);
      
      return result.fold(
        (failure) => Left(failure),
        (roomModel) => Right(roomModel.toEntity()),
      );
    } catch (e) {
      return Left(ServerFailure('Error creando sala: $e'));
    }
  }

  @override
  Future<Either<Failure, Room>> joinRoom({
    required String roomCode,
    required String playerName,
    required String playerId,
  }) async {
    try {
      // Get current room
      final roomResult = await dataSource.getRoomByCode(roomCode);
      
      return await roomResult.fold(
        (failure) async => Left(failure),
        (roomModel) async {
          // Check if room is waiting
          if (roomModel.status != 'waiting') {
            return Left(GameAlreadyStartedFailure('La partida ya ha comenzado'));
          }

          // Create new player
          final newPlayer = RoomPlayerModel(
            id: playerId,
            name: playerName,
            isAlive: true,
            killCount: 0,
            isHost: false,
          );

          // Add player to room
          final joinResult = await dataSource.joinRoom(roomCode, newPlayer);
          
          return await joinResult.fold(
            (failure) => Left(failure),
            (_) async {
              // Get updated room
              final updatedResult = await dataSource.getRoomByCode(roomCode);
              return updatedResult.fold(
                (failure) => Left(failure),
                (updatedRoom) => Right(updatedRoom.toEntity()),
              );
            },
          );
        },
      );
    } catch (e) {
      return Left(ServerFailure('Error uniéndose a la sala: $e'));
    }
  }

  @override
  Future<Either<Failure, Room>> getRoomByCode(String code) async {
    final result = await dataSource.getRoomByCode(code);
    return result.fold(
      (failure) => Left(failure),
      (roomModel) => Right(roomModel.toEntity()),
    );
  }

  @override
  Stream<Either<Failure, Room>> watchRoom(String code) {
    return dataSource.watchRoom(code).map((result) {
      return result.fold(
        (failure) => Left(failure),
        (roomModel) => Right(roomModel.toEntity()),
      );
    });
  }

  @override
  Future<Either<Failure, void>> updateRoomStatus({
    required String roomCode,
    required RoomStatus status,
  }) async {
    final statusString = _roomStatusToString(status);
    return await dataSource.updateRoom(roomCode, {'status': statusString});
  }

  @override
  Future<Either<Failure, void>> addPlayerToRoom({
    required String roomCode,
    required RoomPlayer player,
  }) async {
    final playerModel = RoomPlayerModel.fromEntity(player);
    return await dataSource.joinRoom(roomCode, playerModel);
  }

  @override
  Future<Either<Failure, void>> removePlayerFromRoom({
    required String roomCode,
    required String playerId,
  }) async {
    return await dataSource.updateRoom(roomCode, {
      'players.$playerId': null,
    });
  }

  @override
  Future<Either<Failure, void>> updatePlayer({
    required String roomCode,
    required RoomPlayer player,
  }) async {
    final playerModel = RoomPlayerModel.fromEntity(player);
    return await dataSource.updateRoom(roomCode, {
      'players.${player.id}': playerModel.toMap(),
    });
  }

  @override
  Future<Either<Failure, void>> deleteRoom(String roomCode) async {
    return await dataSource.deleteRoom(roomCode);
  }

  @override
  Future<Either<Failure, Room>> startGame(String roomCode) async {
    try {
      // Get current room
      final roomResult = await dataSource.getRoomByCode(roomCode);
      
      return await roomResult.fold(
        (failure) async => Left(failure),
        (roomModel) async {
          // Check minimum players
          if (roomModel.players.length < 3) {
            return Left(InvalidPlayerCountFailure('Se necesitan al menos 3 jugadores'));
          }

          // Assign targets in a circle
          final playerIds = roomModel.players.keys.toList()..shuffle();
          final updatedPlayers = <String, RoomPlayerModel>{};

          for (int i = 0; i < playerIds.length; i++) {
            final playerId = playerIds[i];
            final targetId = playerIds[(i + 1) % playerIds.length];
            final player = roomModel.players[playerId]!;

            updatedPlayers[playerId] = RoomPlayerModel(
              id: player.id,
              name: player.name,
              isAlive: true,
              targetId: targetId,
              killCount: 0,
              isHost: player.isHost,
            );
          }

          // Update room
          final updateResult = await dataSource.updateRoom(roomCode, {
            'status': 'playing',
            'players': updatedPlayers.map((key, value) => MapEntry(key, value.toMap())),
          });

          return await updateResult.fold(
            (failure) => Left(failure),
            (_) async {
              final updatedResult = await dataSource.getRoomByCode(roomCode);
              return updatedResult.fold(
                (failure) => Left(failure),
                (updatedRoom) => Right(updatedRoom.toEntity()),
              );
            },
          );
        },
      );
    } catch (e) {
      return Left(ServerFailure('Error iniciando juego: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateGameSettings({
    required String roomCode,
    required GameSettings settings,
  }) async {
    try {
      final settingsModel = GameSettingsModel.fromEntity(settings);
      return await dataSource.updateRoom(roomCode, {
        'settings': settingsModel.toMap(),
      });
    } catch (e) {
      return Left(ServerFailure('Error actualizando configuración: $e'));
    }
  }

  /// Generate a random 6-character room code
  String _generateRoomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(6, (_) => chars[random.nextInt(chars.length)]).join();
  }

  String _roomStatusToString(RoomStatus status) {
    switch (status) {
      case RoomStatus.waiting:
        return 'waiting';
      case RoomStatus.playing:
        return 'playing';
      case RoomStatus.finished:
        return 'finished';
    }
  }
}
