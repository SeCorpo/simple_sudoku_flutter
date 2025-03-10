enum LogLevel { verbose, debug, info, warning, error }

class Logger {
  static final Logger _instance = Logger._internal();
  factory Logger() => _instance;

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

  void v(String message, {String? tag}) => log(LogLevel.verbose, message, tag: tag);
  void d(String message, {String? tag}) => log(LogLevel.debug, message, tag: tag);
  void i(String message, {String? tag}) => log(LogLevel.info, message, tag: tag);
  void w(String message, {String? tag}) => log(LogLevel.warning, message, tag: tag);
  void e(String message, {String? tag}) => log(LogLevel.error, message, tag: tag);
}
