import 'package:diary/core/response/api_response.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:shared/shared.dart';

mixin class RepositoryResponseHandlerMixIn {
  ApiResponse<T> apiSuccess<T>(T data) => right(data);

  ApiResponse<T> apiFailureWith<T>({
    ApiErrorCode code = ApiErrorCode.unknown,
    String? message,
    String? scope,
    int? statusCode,
    Object? error,
    StackTrace? stackTrace,
  }) => left(
    ApiException(
      code: code,
      message: message,
      scope: scope,
      statusCode: statusCode,
      error: error,
      stackTrace: stackTrace,
    ),
  );

  ApiResponse<T> fromApiException<T>({
    required Object error,
    StackTrace? stackTrace,
    Logger? logger,
  }) {
    if (error is ApiException) {
      logger?.e('REPOSITORY EXCEPTION', error: error, stackTrace: stackTrace);
      return apiFailureWith(
        code: error.code,
        message: error.message,
        scope: error.scope,
        statusCode: error.statusCode,
        error: error,
        stackTrace: stackTrace ?? error.stackTrace,
      );
    } else {
      logger?.e('REPOSITORY EXCEPTION', error: error, stackTrace: stackTrace);
      return apiFailureWith(
        error: error,
        stackTrace: stackTrace,
        scope: 'REPOSITORY',
      );
    }
  }
}
