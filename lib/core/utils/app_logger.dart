import 'dart:developer' as developer;

/// Global logger for the application using Dart's native logging
/// 
/// Usage:
/// ```dart
/// AppLogger.debug('GameSetup', 'Debug message');
/// AppLogger.info('GameSetup', 'Info message');
/// AppLogger.warning('GameSetup', 'Warning message');
/// AppLogger.error('GameSetup', 'Error message', error: error);
/// ```
class AppLogger {
  AppLogger._();

  static void debug(String tag, String message, {Object? data}) {
    print('🔵 DEBUG [$tag]: $message${data != null ? ' | Data: $data' : ''}');
    developer.log(
      message,
      name: tag,
      level: 500, // DEBUG level
      error: data,
    );
  }

  static void info(String tag, String message, {Object? data}) {
    print('ℹ️ INFO [$tag]: $message${data != null ? ' | Data: $data' : ''}');
    developer.log(
      message,
      name: tag,
      level: 800, // INFO level
      error: data,
    );
  }

  static void warning(String tag, String message, {Object? data}) {
    print('⚠️ WARNING [$tag]: $message${data != null ? ' | Data: $data' : ''}');
    developer.log(
      message,
      name: tag,
      level: 900, // WARNING level
      error: data,
    );
  }

  static void error(String tag, String message, {Object? error, StackTrace? stackTrace}) {
    print('❌ ERROR [$tag]: $message${error != null ? ' | Error: $error' : ''}');
    developer.log(
      message,
      name: tag,
      level: 1000, // ERROR level
      error: error,
      stackTrace: stackTrace,
    );
  }
}
