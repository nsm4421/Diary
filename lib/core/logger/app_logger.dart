import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@module
abstract class AppLoggerModule {
  @lazySingleton
  Logger get logger => Logger(
    level: kReleaseMode ? Level.warning : Level.all,
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 5,
      lineLength: 120,
      printEmojis: true,
    ),
  );
}