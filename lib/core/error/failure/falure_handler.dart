import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../api/api_error.dart';
import 'failure.dart';

@lazySingleton
mixin class FailureHandlerMixin {
  Either<Failure, T> mapApiResult<T>(Either<ApiError, T> result) {
    return result.fold(
      (error) => failureFromApiError(error).toLeft(),
      Right.new,
    );
  }

  Failure failureFromApiError(ApiError error) {
    return Failure.fromCode(
      error.code.toFailureCode(),
      details: error,
    );
  }
}
