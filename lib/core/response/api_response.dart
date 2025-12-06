import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';

typedef ApiResponse<T> = Either<ApiException, T>;

extension ApiResponseX<T> on ApiResponse<T> {
  bool get isSuccess => isRight();

  bool get isFailure => isLeft();

  T? get dataOrNull => fold((_) => null, (r) => r);

  ApiException? get errorOrNull => fold<ApiException?>((l) => l, (_) => null);
}
