import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'app_exception.dart';
import 'failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;

typedef FutureCallback<T> = Future<T> Function();

@lazySingleton
class ErrorHandler {
  const ErrorHandler();

  FutureEither<T> guard<T>(FutureCallback<T> run) async {
    try {
      final result = await run();
      return Right(result);
    } on AppException catch (exception) {
      return Left(Failure.fromException(exception));
    } catch (error, stackTrace) {
      return Left(
        Failure.unknown(message: error.toString(), stackTrace: stackTrace),
      );
    }
  }
}
