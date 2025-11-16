import 'package:dartz/dartz.dart';
import 'package:diary/core/constant/api_error_code.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../value_objects/error/api_error.dart';
import '../value_objects/error/api_exception.dart';

typedef FutureApiResult<T> = Future<Either<ApiError, T>>;

typedef FutureCallback<T> = Future<T> Function();

@lazySingleton
mixin class ApiErrorHandlerMiIn {
  FutureApiResult<T> guard<T>(
    FutureCallback<T> run, {
    Logger? logger,
    ApiErrorCode fallbackCode = ApiErrorCode.unknown,
  }) async {
    try {
      return Right(await run());
    } on ApiException catch (exception) {
      logger?.e(
        exception.message,
        error: exception.error.details,
        stackTrace: exception.stackTrace,
      );
      return Left(exception.toApiError());
    } catch (error, stackTrace) {
      logger?.e(error, stackTrace: stackTrace);
      final exception = ApiException.fromCode(
        fallbackCode,
        message: error.toString(),
        details: error,
        stackTrace: stackTrace,
      );
      return Left(exception.toApiError());
    }
  }

  Future<T> runDatabase<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on ApiException {
      rethrow;
    } catch (error, stackTrace) {
      throw ApiException.database(
        message: error.toString(),
        details: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<T> runStorage<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on ApiException {
      rethrow;
    } catch (error, stackTrace) {
      throw ApiException.storage(
        message: error.toString(),
        details: error,
        stackTrace: stackTrace,
      );
    }
  }
}

