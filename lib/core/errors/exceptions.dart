/// Base class for all exceptions in the application
/// Exceptions are thrown at the data layer and converted to Failures
class AppException implements Exception {
  final String message;
  final int? code;

  const AppException(this.message, [this.code]);

  @override
  String toString() => 'AppException: $message${code != null ? ' (code: $code)' : ''}';
}

// Server/API exceptions
class ServerException extends AppException {
  const ServerException([String message = 'Server error', int? code])
      : super(message, code);
}

class NetworkException extends AppException {
  const NetworkException([String message = 'Network error']) : super(message);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([String message = 'Unauthorized access'])
      : super(message, 401);
}

class NotFoundException extends AppException {
  const NotFoundException([String message = 'Resource not found'])
      : super(message, 404);
}

// Cache/Storage exceptions
class CacheException extends AppException {
  const CacheException([String message = 'Cache error']) : super(message);
}

class StorageException extends AppException {
  const StorageException([String message = 'Storage error']) : super(message);
}

// Serialization exceptions
class SerializationException extends AppException {
  const SerializationException([String message = 'Serialization error'])
      : super(message);
}

class DeserializationException extends AppException {
  const DeserializationException([String message = 'Deserialization error'])
      : super(message);
}

// Validation exceptions
class ValidationException extends AppException {
  final Map<String, String>? errors;

  const ValidationException(
    String message, [
    this.errors,
  ]) : super(message);

  @override
  String toString() {
    if (errors == null || errors!.isEmpty) {
      return super.toString();
    }
    return 'ValidationException: $message\nErrors: $errors';
  }
}

// Game-specific exceptions
class InvalidPlayerCountException extends AppException {
  const InvalidPlayerCountException([String message = 'Invalid player count'])
      : super(message);
}

class DuplicatePlayerException extends AppException {
  const DuplicatePlayerException([String message = 'Duplicate player name'])
      : super(message);
}

class GameNotFoundException extends AppException {
  const GameNotFoundException([String message = 'Game not found'])
      : super(message);
}

class AssignmentNotFoundException extends AppException {
  const AssignmentNotFoundException([String message = 'Assignment not found'])
      : super(message);
}

class InvalidGameStateException extends AppException {
  const InvalidGameStateException([String message = 'Invalid game state'])
      : super(message);
}

// Future: Multiplayer exceptions
class RoomException extends AppException {
  const RoomException([String message = 'Room error']) : super(message);
}

class RoomFullException extends AppException {
  const RoomFullException([String message = 'Room is full']) : super(message);
}

class RoomNotFoundException extends AppException {
  const RoomNotFoundException([String message = 'Room not found'])
      : super(message);
}

class ConnectionException extends AppException {
  const ConnectionException([String message = 'Connection error'])
      : super(message);
}

