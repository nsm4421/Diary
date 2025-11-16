import 'package:logger/logger.dart';

import '../error/failure/failure.dart';

extension UseCaseLoggerExtension on Logger {
  void useCaseTrace(String scope, String message) {
    t('$scope $message');
  }

  void useCaseSuccess(String scope, String message) {
    t('$scope $message');
  }

  void useCaseFail(String scope, Failure failure, {String? hint}) {
    final prefix = hint == null ? '$scope 실패' : '$scope $hint 실패';
    e(
      '$prefix: ${failure.description}',
      error: failure.details ?? failure,
      stackTrace: failure.stackTrace,
    );
  }

  void useCaseError(
    String scope,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    e('$scope $message', error: error, stackTrace: stackTrace);
  }
}
