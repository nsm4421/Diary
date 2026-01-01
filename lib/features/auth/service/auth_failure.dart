import 'package:diary/core/core.dart';
import 'package:logger/logger.dart';

class AuthFailure extends Failure {
  AuthFailure({
    required super.message,
    super.error,
    super.stackTrace,
    Logger? logger,
  }) {
    logger?.e('[AUTH]$message', error: error, stackTrace: stackTrace);
  }
}
