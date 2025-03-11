enum LogLevel { debug, info, warning, error, none }

class Logger {
  Logger._(); // Private constructor prevents instantiation

  static LogLevel _logLevel = LogLevel.debug;

  static const String _resetColor = '\x1B[0m';

  static void setLogLevel(LogLevel level) {
    _logLevel = level;
  }

  static void d(String message, {String? tag}) {
    _log(LogLevel.debug, '\x1B[36m', "DEBUG", message, tag); // Cyan
  }

  static void i(String message, {String? tag}) {
    _log(LogLevel.info, '\x1B[32m', "INFO", message, tag); // Green
  }

  static void w(String message, {String? tag}) {
    _log(LogLevel.warning, '\x1B[33m', "WARNING", message, tag); // Yellow
  }

  static void e(String message, {String? tag}) {
    _log(LogLevel.error, '\x1B[31m', "ERROR", message, tag); // Red
  }

  static void _log(LogLevel level, String color, String levelName, String message, String? tag) {
    if (level.index < _logLevel.index) return; // Skip logs below the set level

    final tagPrefix = tag != null ? '[$tag] ' : '';
    print('$color$levelName$_resetColor: $tagPrefix$message');
  }
}
