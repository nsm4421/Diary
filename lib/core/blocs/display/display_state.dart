part of 'display_bloc.dart';

@freezed
class DisplayState<E> with _$DisplayState<E> {
  const factory DisplayState.idle() = _Idle<E>;

  const factory DisplayState.loading(List<E> items) = _Loading<E>;

  const factory DisplayState.paginated(List<E> items) = _Paginated<E>;

  const factory DisplayState.pageEnd(List<E> items) = _PageEnd<E>;

  const factory DisplayState.failure({
    required List<E> items,
    required Failure failure,
  }) = _Failure<E>;
}

extension DisplayStateX<E> on DisplayState<E> {
  bool get canRequestNextPage =>
      whenOrNull(idle: () => true, paginated: (_) => true) ?? false;

  List<E> get items => when(
    idle: () => [],
    loading: (items) => items,
    paginated: (items) => items,
    pageEnd: (items) => items,
    failure: (items, _) => items,
  );
}
