import 'api_error.dart';

class ApiException implements Exception {
  ApiException({
    required this.code,
    required this.message,
    this.details,
    this.stackTrace,
  }) : error = ApiError(
          code: code,
          message: message,
          details: details,
        );

  factory ApiException.fromCode(
    ApiErrorCode code, {
    String? message,
    Object? details,
    StackTrace? stackTrace,
  }) {
    return ApiException(
      code: code,
      message: message ?? code.description,
      details: details,
      stackTrace: stackTrace,
    );
  }

  factory ApiException.validation({
    String? message,
    Object? details,
    StackTrace? stackTrace,
  }) {
    return ApiException.fromCode(
      ApiErrorCode.validation,
      message: message,
      details: details,
      stackTrace: stackTrace,
    );
  }

  factory ApiException.notFound({
    String? message,
    Object? details,
    StackTrace? stackTrace,
  }) {
    return ApiException.fromCode(
      ApiErrorCode.notFound,
      message: message,
      details: details,
      stackTrace: stackTrace,
    );
  }

  factory ApiException.database({
    String? message,
    Object? details,
    StackTrace? stackTrace,
  }) {
    return ApiException.fromCode(
      ApiErrorCode.database,
      message: message,
      details: details,
      stackTrace: stackTrace,
    );
  }

  factory ApiException.cache({
    String? message,
    Object? details,
    StackTrace? stackTrace,
  }) {
    return ApiException.fromCode(
      ApiErrorCode.cache,
      message: message,
      details: details,
      stackTrace: stackTrace,
    );
  }

  factory ApiException.storage({
    String? message,
    Object? details,
    StackTrace? stackTrace,
  }) {
    return ApiException.fromCode(
      ApiErrorCode.storage,
      message: message,
      details: details,
      stackTrace: stackTrace,
    );
  }

  factory ApiException.unknown({
    String? message,
    Object? details,
    StackTrace? stackTrace,
  }) {
    return ApiException.fromCode(
      ApiErrorCode.unknown,
      message: message,
      details: details,
      stackTrace: stackTrace,
    );
  }

  final ApiErrorCode code;
  final String message;
  final Object? details;
  final StackTrace? stackTrace;
  final ApiError error;

  ApiError toApiError() => error;

  @override
  String toString() {
    return 'ApiException(${code.code}): $message';
  }
}
