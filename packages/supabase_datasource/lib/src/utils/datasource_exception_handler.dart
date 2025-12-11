import 'dart:async';
import 'dart:io';

import 'package:shared/shared.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

mixin class SupabaseDataSourceExceptionHandlerMixIn {
  ApiException toApiException(Object error, StackTrace stackTrace) {
    if (error is ApiException) {
      return error;
    } else if (error is PostgrestException) {
      return _fromStatusCode(
        statusCode: int.tryParse(error.code ?? ''),
        message: error.message,
        error: error,
        stackTrace: stackTrace,
      );
    } else if (error is StorageException) {
      return _fromStatusCode(
        statusCode: int.tryParse(error.statusCode ?? ''),
        message: error.message,
        error: error,
        stackTrace: stackTrace,
      );
    } else if (error is AuthException) {
      return ApiException.unauthorized(
        message: error.message,
        statusCode: int.tryParse(error.statusCode ?? '400'),
        error: error,
        stackTrace: stackTrace,
      );
    } else if (error is SocketException) {
      return ApiException.network(
        message: error.message,
        error: error,
        stackTrace: stackTrace,
      );
    } else if (error is TimeoutException) {
      return ApiException.timeout(
        message: error.message,
        error: error,
        stackTrace: stackTrace,
      );
    } else {
      return ApiException.unknown(
        message: error.toString(),
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  ApiException _fromStatusCode({
    required int? statusCode,
    required String message,
    required Object error,
    required StackTrace stackTrace,
  }) {
    switch (statusCode) {
      case 400:
      case 406:
        return ApiException.badRequest(
          message: message,
          statusCode: statusCode,
          error: error,
          stackTrace: stackTrace,
        );
      case 401:
        return ApiException.unauthorized(
          message: message,
          statusCode: statusCode,
          error: error,
          stackTrace: stackTrace,
        );
      case 403:
        return ApiException.forbidden(
          message: message,
          statusCode: statusCode,
          error: error,
          stackTrace: stackTrace,
        );
      case 404:
        return ApiException.notFound(
          message: message,
          statusCode: statusCode,
          error: error,
          stackTrace: stackTrace,
        );
      case 408:
        return ApiException.timeout(
          message: message,
          statusCode: statusCode,
          error: error,
          stackTrace: stackTrace,
        );
      case 409:
        return ApiException.conflict(
          message: message,
          statusCode: statusCode,
          error: error,
          stackTrace: stackTrace,
        );
      case 422:
        return ApiException.validation(
          message: message,
          statusCode: statusCode,
          error: error,
          stackTrace: stackTrace,
        );
    }

    if (statusCode != null && statusCode >= 500) {
      return ApiException.server(
        message: message,
        statusCode: statusCode,
        error: error,
        stackTrace: stackTrace,
      );
    } else if (statusCode != null && statusCode >= 400) {
      return ApiException.badRequest(
        message: message,
        statusCode: statusCode,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return ApiException.unknown(
      message: message,
      statusCode: statusCode,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
