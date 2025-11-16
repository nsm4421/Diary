import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

@lazySingleton
mixin class AppLoggerMixIn {
  Logger? _logger;

  Logger get logger => _logger ??= _createDefaultLogger();

  @visibleForTesting
  void setLogger(Logger logger) {
    _logger = logger;
  }

  Logger _createDefaultLogger() {
    return Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 100,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTime,
      ),
      level: Level.debug,
    );
  }
}
