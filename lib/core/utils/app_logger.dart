import 'package:diary/core/response/failure.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@module
abstract class AppLoggerModule {
  @lazySingleton
  Logger get logger => Logger(
    level: kReleaseMode ? Level.warning : Level.debug,
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 5,
      lineLength: 120,
      printEmojis: true,
      printTime: true,
    ),
  );
}

extension LoggerFailureX on Logger {
  void fail(Failure failure) {
    e(
      'code=${failure.code} status=${failure.statusCode ?? '-'} message=${failure.message}',
      error: failure.error ?? failure,
      stackTrace: failure.stackTrace,
    );
  }
}
