import 'package:equatable/equatable.dart';

import '../constant/error_code.dart';

enum ApiErrorCode {
  badRequest('BAD_REQUEST', 'Bad request.'),
  unauthorized('UNAUTHORIZED', 'Authentication required.'),
  forbidden('FORBIDDEN', 'Access forbidden.'),
  notFound('NOT_FOUND', 'Resource not found.'),
  conflict('CONFLICT', 'Request conflicts with current state.'),
  server('SERVER_ERROR', 'Server error occurred.'),
  network('NETWORK_ERROR', 'Network error occurred.'),
  timeout('TIMEOUT', 'Request timed out.'),
  cache('CACHE_ERROR', 'Cache read/write failed.'),
  database('DATABASE_ERROR', 'Database operation failed.'),
  storage('STORAGE_ERROR', 'Storage operation failed.'),
  parsing('PARSING_ERROR', 'Parsing failed.'),
  validation('VALIDATION_ERROR', 'Validation failed.'),
  cancelled('CANCELLED', 'Request cancelled.'),
  unknown('UNKNOWN', 'Unknown error occurred.');

  const ApiErrorCode(this.code, this.description);

  final String code;
  final String description;

  ErrorCode toFailureCode() {
    switch (this) {
      case ApiErrorCode.badRequest:
        return ErrorCode.badRequest;
      case ApiErrorCode.unauthorized:
        return ErrorCode.unauthorized;
      case ApiErrorCode.forbidden:
        return ErrorCode.forbidden;
      case ApiErrorCode.notFound:
        return ErrorCode.notFound;
      case ApiErrorCode.conflict:
        return ErrorCode.conflict;
      case ApiErrorCode.server:
        return ErrorCode.server;
      case ApiErrorCode.network:
        return ErrorCode.network;
      case ApiErrorCode.timeout:
        return ErrorCode.timeout;
      case ApiErrorCode.cache:
        return ErrorCode.cache;
      case ApiErrorCode.database:
        return ErrorCode.database;
      case ApiErrorCode.storage:
        return ErrorCode.storage;
      case ApiErrorCode.parsing:
        return ErrorCode.parsing;
      case ApiErrorCode.validation:
        return ErrorCode.validation;
      case ApiErrorCode.cancelled:
        return ErrorCode.cancelled;
      case ApiErrorCode.unknown:
        return ErrorCode.unknown;
    }
  }
}

class ApiError extends Equatable {
  const ApiError({
    required this.code,
    required this.message,
    this.details,
  });

  final ApiErrorCode code;
  final String message;
  final Object? details;

  @override
  List<Object?> get props => [code, message, details];
}
