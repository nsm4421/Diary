import 'package:dartz/dartz.dart';
import 'package:diary/core/value_objects/error/api_error.dart';
import 'package:diary/core/extension/api_error_code_extension.dart';
import 'package:injectable/injectable.dart';

import '../value_objects/error/failure.dart';

@lazySingleton
mixin class FailureHandlerMixin {
  Either<Failure, T> mapApiResult<T>(Either<ApiError, T> result) {
    return result.fold(
      (error) => failureFromApiError(error).toLeft(),
      Right.new,
    );
  }

  Failure failureFromApiError(ApiError error) {
    return Failure.fromCode(error.code.toFailureCode(), details: error);
  }
}
