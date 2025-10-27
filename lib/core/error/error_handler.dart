import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'app_exception.dart';
import 'failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;

typedef FutureCallback<T> = Future<T> Function();

@lazySingleton
mixin class ErrorHandlerMiIn {
  FutureEither<T> guard<T>(FutureCallback<T> run) async {
    try {
      return Right(await run());
    } on AppException catch (exception) {
      return Failure.fromException(exception).toLeft();
    } catch (error, stackTrace) {
      return Failure.unknown(
        message: error.toString(),
        stackTrace: stackTrace,
      ).toLeft();
    }
  }
}
