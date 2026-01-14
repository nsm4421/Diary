import 'package:logger/logger.dart';
import 'package:shared/shared.dart';

extension LoggerExtension on Logger {
  void failure(Failure failure, {String? message}) {
    e(
      message ?? failure.message,
      error: failure.error,
      stackTrace: failure.stackTrace,
    );
  }
}
