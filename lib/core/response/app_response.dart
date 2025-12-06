import 'package:fpdart/fpdart.dart';

import 'api_response.dart';
import 'failure.dart';

typedef AppResponse<T> = Either<Failure, T>;

extension AppResponseX<T> on AppResponse<T> {
  bool get isSuccess => isRight();

  bool get isFailure => isLeft();

  T? get dataOrNull => fold((_) => null, (r) => r);

  Failure? get failureOrNull => fold((l) => l, (_) => null);

  AppResponse<R> mapSuccess<R>(R Function(T value) convert) =>
      map(convert.call);

  AppResponse<T> mapFailure(Failure Function(Failure failure) convert) =>
      mapLeft(convert.call);
}

extension AppResponseFromApi<T> on ApiResponse<T> {
  AppResponse<T> toAppResponse() => mapLeft(Failure.fromApiException);
}
