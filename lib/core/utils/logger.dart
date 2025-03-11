enum LogLevel { verbose, debug, info, warning, error }

class Logger {
  static final Logger instance = Logger._internal(); // Direct static access
  factory Logger() => instance; // Ensures the singleton pattern

  LogLevel _logLevel = LogLevel.verbose;

  Logger._internal();

  static const Map<LogLevel, String> _logColors = {
    LogLevel.verbose: '\x1B[37m', // White
    LogLevel.debug: '\x1B[36m', // Cyan
    LogLevel.info: '\x1B[32m', // Green
    LogLevel.warning: '\x1B[33m', // Yellow
    LogLevel.error: '\x1B[31m', // Red
  };

  static const String _resetColor = '\x1B[0m';

  void setLogLevel(LogLevel level) {
    _logLevel = level;
  }

  void log(LogLevel level, String message, {String? tag}) {
    if (level.index < _logLevel.index) return;

    final color = _logColors[level] ?? _resetColor;
    final tagPrefix = tag != null ? '[$tag] ' : '';
    final logMessage =
        '$color${level.name.toUpperCase()}$_resetColor: $tagPrefix$message';

    print(logMessage);
  }

  static void v(String message, {String? tag}) => instance.log(LogLevel.verbose, message, tag: tag);
  static void d(String message, {String? tag}) => instance.log(LogLevel.debug, message, tag: tag);
  static void i(String message, {String? tag}) => instance.log(LogLevel.info, message, tag: tag);
  static void w(String message, {String? tag}) => instance.log(LogLevel.warning, message, tag: tag);
  static void e(String message, {String? tag}) => instance.log(LogLevel.error, message, tag: tag);
}
