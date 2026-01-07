import 'package:diary/core/core.dart';
import 'package:logger/logger.dart';

class VoteFailure extends Failure {
  VoteFailure({
    required super.message,
    super.error,
    super.stackTrace,
    Logger? logger,
  }) {
    logger?.e('[VOTE]$message', error: error, stackTrace: stackTrace);
  }
}
