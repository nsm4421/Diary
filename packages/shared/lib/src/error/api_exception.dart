import 'api_error_code.dart';

class ApiException implements Exception {
  const ApiException({
    this.code = ApiErrorCode.unknown,
    this.message,
    this.scope,
    this.statusCode,
    this.error,
    this.stackTrace,
  });

  final ApiErrorCode code;
  final String? message;
  final String? scope;
  final int? statusCode;
  final Object? error;
  final StackTrace? stackTrace;

  @override
  String toString() {
    final base = message ?? code.description;
    final status = statusCode != null ? ' (status: $statusCode)' : '';
    return 'ApiError(code: ${code.code}, message: $base$status)';
  }

  static ApiException _from({
    required ApiErrorCode code,
    String? message,
    String? scope,
    int? statusCode,
    Object? error,
    StackTrace? stackTrace,
  }) => ApiException(
    code: code,
    message: message,
    scope: scope,
    statusCode: statusCode,
    error: error,
    stackTrace: stackTrace,
  );

  /// Quick factories per error code for convenience.
  static ApiException badRequest({
    String? message,
    String? scope,
    int? statusCode,
    Object? error,
    StackTrace? stackTrace,
  }) => _from(
    code: ApiErrorCode.badRequest,
    message: message,
    scope: scope,
    statusCode: statusCode,
    error: error,
    stackTrace: stackTrace,
  );

  static ApiException unauthorized({
    String? message,
    String? scope,
    int? statusCode,
    Object? error,
    StackTrace? stackTrace,
  }) => _from(
    code: ApiErrorCode.unauthorized,
    message: message,
    scope: scope,
    statusCode: statusCode,
    error: error,
    stackTrace: stackTrace,
  );

  static ApiException forbidden({
    String? message,
    String? scope,
    int? statusCode,
    Object? error,
    StackTrace? stackTrace,
  }) => _from(
    code: ApiErrorCode.forbidden,
    message: message,
    scope: scope,
    statusCode: statusCode,
    error: error,
    stackTrace: stackTrace,
  );

  static ApiException notFound({
    String? message,
    String? scope,
    int? statusCode,
    Object? error,
    StackTrace? stackTrace,
  }) => _from(
    code: ApiErrorCode.notFound,
    message: message,
    scope: scope,
    statusCode: statusCode,
    error: error,
    stackTrace: stackTrace,
  );

  static ApiException conflict({
    String? message,
    String? scope,
    int? statusCode,
    Object? error,
    StackTrace? stackTrace,
  }) => _from(
    code: ApiErrorCode.conflict,
    message: message,
    scope: scope,
    statusCode: statusCode,
    error: error,
    stackTrace: stackTrace,
  );

  static ApiException server({
    String? message,
    String? scope,
    int? statusCode,
    Object? error,
    StackTrace? stackTrace,
  }) => _from(
    code: ApiErrorCode.server,
    message: message,
    scope: scope,
    statusCode: statusCode,
    error: error,
    stackTrace: stackTrace,
  );

  static ApiException network({
    String? message,
    String? scope,
    int? statusCode,
    Object? error,
    StackTrace? stackTrace,
  }) => _from(
    code: ApiErrorCode.network,
    message: message,
    scope: scope,
    statusCode: statusCode,
    error: error,
    stackTrace: stackTrace,
  );

  static ApiException timeout({
    String? message,
    String? scope,
    int? statusCode,
    Object? error,
    StackTrace? stackTrace,
  }) => _from(
    code: ApiErrorCode.timeout,
    message: message,
    scope: scope,
    statusCode: statusCode,
    error: error,
    stackTrace: stackTrace,
  );

  static ApiException cache({
    String? message,
    String? scope,
    int? statusCode,
    Object? error,
    StackTrace? stackTrace,
  }) => _from(
    code: ApiErrorCode.cache,
    message: message,
    scope: scope,
    statusCode: statusCode,
    error: error,
    stackTrace: stackTrace,
  );

  static ApiException parsing({
    String? message,
    String? scope,
    int? statusCode,
    Object? error,
    StackTrace? stackTrace,
  }) => _from(
    code: ApiErrorCode.parsing,
    message: message,
    scope: scope,
    statusCode: statusCode,
    error: error,
    stackTrace: stackTrace,
  );

  static ApiException validation({
    String? message,
    String? scope,
    int? statusCode,
    Object? error,
    StackTrace? stackTrace,
  }) => _from(
    code: ApiErrorCode.validation,
    message: message,
    scope: scope,
    statusCode: statusCode,
    error: error,
    stackTrace: stackTrace,
  );

  static ApiException cancelled({
    String? message,
    String? scope,
    int? statusCode,
    Object? error,
    StackTrace? stackTrace,
  }) => _from(
    code: ApiErrorCode.cancelled,
    message: message,
    scope: scope,
    statusCode: statusCode,
    error: error,
    stackTrace: stackTrace,
  );

  static ApiException unknown({
    String? message,
    String? scope,
    int? statusCode,
    Object? error,
    StackTrace? stackTrace,
  }) => _from(
    code: ApiErrorCode.unknown,
    message: message,
    scope: scope,
    statusCode: statusCode,
    error: error,
    stackTrace: stackTrace,
  );
}
