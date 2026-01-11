part of 'create_bloc.dart';

@freezed
abstract class CreateState<T> with _$CreateState<T> {
  const factory CreateState.editing(T data) = _Editing<T>;

  const factory CreateState.submitting(T data) = _Submitting<T>;

  const factory CreateState.success(T data) = _Success<T>;

  const factory CreateState.failure({
    required T data,
    required Failure failure,
  }) = _Failure<T>;
}

extension CreateStateX<T> on CreateState<T> {
  bool get canEditable => whenOrNull(editing: (_) => true) ?? false;

  bool get isLoading => whenOrNull(editing: (_) => false) ?? true;

  bool get isError => whenOrNull(failure: (_, __) => true) ?? false;

  bool get isSuccess => whenOrNull(success: (_) => true) ?? false;

  String? get errorMessage =>
      whenOrNull(failure: (_, failure) => failure.message);

  T get data => when(
    editing: (d) => d,
    submitting: (d) => d,
    success: (d) => d,
    failure: (d, _) => d,
  );
}
