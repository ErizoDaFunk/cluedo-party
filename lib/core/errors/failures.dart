import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
/// Failures represent errors at the domain/business logic level
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Error del servidor']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Error al acceder al almacenamiento local'])
      : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Error de conexión a internet'])
      : super(message);
}

// Game-specific failures
class InvalidPlayerCountFailure extends Failure {
  const InvalidPlayerCountFailure(
      [String message = 'Número de jugadores inválido']) : super(message);
}

class DuplicatePlayerFailure extends Failure {
  const DuplicatePlayerFailure(
      [String message = 'Ya existe un jugador con ese nombre']) : super(message);
}

class EmptyPlayerNameFailure extends Failure {
  const EmptyPlayerNameFailure(
      [String message = 'El nombre del jugador no puede estar vacío'])
      : super(message);
}

class NoActiveGameFailure extends Failure {
  const NoActiveGameFailure([String message = 'No hay ningún juego activo'])
      : super(message);
}

class GameAlreadyStartedFailure extends Failure {
  const GameAlreadyStartedFailure([String message = 'El juego ya ha comenzado'])
      : super(message);
}

class AssignmentNotFoundFailure extends Failure {
  const AssignmentNotFoundFailure(
      [String message = 'No se encontró la asignación']) : super(message);
}

class AssignmentAlreadyRevealedFailure extends Failure {
  const AssignmentAlreadyRevealedFailure(
      [String message = 'La asignación ya ha sido revelada']) : super(message);
}

class InvalidGameConfigFailure extends Failure {
  const InvalidGameConfigFailure(
      [String message = 'Configuración del juego inválida']) : super(message);
}

// Data failures
class SerializationFailure extends Failure {
  const SerializationFailure(
      [String message = 'Error al procesar los datos']) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Error de validación'])
      : super(message);
}

// Future: Multiplayer failures
class RoomNotFoundFailure extends Failure {
  const RoomNotFoundFailure([String message = 'Sala no encontrada'])
      : super(message);
}

class RoomFullFailure extends Failure {
  const RoomFullFailure([String message = 'La sala está llena']) : super(message);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure([String message = 'Error de conexión con la sala'])
      : super(message);
}

