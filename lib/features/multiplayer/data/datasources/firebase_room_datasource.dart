import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../models/room_model.dart';

abstract class FirebaseRoomDataSource {
  /// Create a new room in Firestore
  Future<Either<Failure, RoomModel>> createRoom(RoomModel room);
  
  /// Get a room by code
  Future<Either<Failure, RoomModel>> getRoomByCode(String code);
  
  /// Listen to room changes
  Stream<Either<Failure, RoomModel>> watchRoom(String code);
  
  /// Join a room (add player)
  Future<Either<Failure, void>> joinRoom(String code, RoomPlayerModel player);
  
  /// Update room
  Future<Either<Failure, void>> updateRoom(String code, Map<String, dynamic> updates);
  
  /// Delete room
  Future<Either<Failure, void>> deleteRoom(String code);
}

class FirebaseRoomDataSourceImpl implements FirebaseRoomDataSource {
  final FirebaseFirestore firestore;
  static const String _collection = 'rooms';

  FirebaseRoomDataSourceImpl({required this.firestore});

  @override
  Future<Either<Failure, RoomModel>> createRoom(RoomModel room) async {
    try {
      await firestore.collection(_collection).doc(room.code).set(room.toFirestore());
      return Right(room);
    } catch (e) {
      return Left(ServerFailure('Error creando sala: $e'));
    }
  }

  @override
  Future<Either<Failure, RoomModel>> getRoomByCode(String code) async {
    try {
      final doc = await firestore.collection(_collection).doc(code).get();
      
      if (!doc.exists) {
        return Left(NotFoundFailure(message: 'Sala no encontrada'));
      }
      
      return Right(RoomModel.fromFirestore(doc));
    } catch (e) {
      return Left(ServerFailure('Error obteniendo sala: $e'));
    }
  }

  @override
  Stream<Either<Failure, RoomModel>> watchRoom(String code) {
    print('🔷 [Datasource] Setting up Firestore listener for room: $code');
    return firestore.collection(_collection).doc(code).snapshots().map((doc) {
      print('🔷 [Datasource] Snapshot received - exists: ${doc.exists}');
      try {
        if (!doc.exists) {
          print('🔴 [Datasource] Room not found!');
          return Left(NotFoundFailure(message: 'Sala no encontrada'));
        }
        final roomModel = RoomModel.fromFirestore(doc);
        print('🔷 [Datasource] Room parsed - ${roomModel.players.length} players');
        roomModel.players.forEach((id, player) {
          print('  👤 [Datasource] Player: ${player.name}');
        });
        return Right(roomModel);
      } catch (e) {
        print('🔴 [Datasource] Error: $e');
        return Left(ServerFailure('Error observando sala: $e'));
      }
    });
  }

  @override
  Future<Either<Failure, void>> joinRoom(String code, RoomPlayerModel player) async {
    try {
      await firestore.collection(_collection).doc(code).update({
        'players.${player.id}': player.toMap(),
      });
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Error uniéndose a la sala: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateRoom(String code, Map<String, dynamic> updates) async {
    try {
      await firestore.collection(_collection).doc(code).update(updates);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Error actualizando sala: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRoom(String code) async {
    try {
      await firestore.collection(_collection).doc(code).delete();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Error eliminando sala: $e'));
    }
  }
}
