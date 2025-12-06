import 'dart:async';
import 'dart:io';

import 'package:shared/shared.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

mixin class SupabaseDataSourceExceptionHandlerMixIn {
  ApiException toApiException(Object error, StackTrace stackTrace) {
    if (error is AuthException) {
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
}
