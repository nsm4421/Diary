import 'package:diary/core/constant/api_error_code.dart';
import 'package:diary/core/constant/error_code.dart';

extension ApiErrorCodeExtension on ApiErrorCode {
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
