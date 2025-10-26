import 'error_code.dart';

class AppException implements Exception {
  const AppException({
    required this.code,
    required this.message,
    this.statusCode,
    this.details,
    this.stackTrace,
  });

  final ErrorCode code;
  final String message;
  final int? statusCode;
  final Object? details;
  final StackTrace? stackTrace;

  factory AppException.server({
    required String message,
    int? statusCode,
    Object? details,
    StackTrace? stackTrace,
  }) {
    return AppException(
      code: ErrorCode.server,
      message: message,
      statusCode: statusCode,
      details: details,
      stackTrace: stackTrace,
    );
  }

  factory AppException.cache({
    required String message,
    Object? details,
    StackTrace? stackTrace,
  }) {
    return AppException(
      code: ErrorCode.cache,
      message: message,
      details: details,
      stackTrace: stackTrace,
    );
  }

  factory AppException.network({
    required String message,
    Object? details,
    StackTrace? stackTrace,
  }) {
    return AppException(
      code: ErrorCode.network,
      message: message,
      details: details,
      stackTrace: stackTrace,
    );
  }

  factory AppException.timeout({
    required String message,
    Object? details,
    StackTrace? stackTrace,
  }) {
    return AppException(
      code: ErrorCode.timeout,
      message: message,
      details: details,
      stackTrace: stackTrace,
    );
  }

  factory AppException.validation({
    required String message,
    Object? details,
    StackTrace? stackTrace,
  }) {
    return AppException(
      code: ErrorCode.validation,
      message: message,
      details: details,
      stackTrace: stackTrace,
    );
  }

  factory AppException.unknown({
    required String message,
    Object? details,
    StackTrace? stackTrace,
  }) {
    return AppException(
      code: ErrorCode.unknown,
      message: message,
      details: details,
      stackTrace: stackTrace,
    );
  }
}
