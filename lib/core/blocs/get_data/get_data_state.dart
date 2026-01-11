part of 'get_data_cubit.dart';

@freezed
abstract class GetDataState<T> with _$GetDataState<T> {
  const factory GetDataState.idle() = _Idle<T>;

  const factory GetDataState.loading() = _Loading<T>;

  const factory GetDataState.success(T data) = _Success<T>;

  const factory GetDataState.failure(Failure failure) = _Failure<T>;
}

extension GetDataStateExtension<T> on GetDataState<T> {
  bool get isIdle => whenOrNull(idle: () => true) ?? false;

  bool get isLoading => whenOrNull(loading: () => true) ?? false;

  bool get isFetched => whenOrNull(success: (_) => true) ?? false;

  bool get isError => whenOrNull(failure: (_) => true) ?? false;

  T? get data => whenOrNull(success: (data) => data);
}
