import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
mixin class AppLoggerMixIn {
  final Logger _logger = Logger(
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

  Logger get logger => _logger;
}
