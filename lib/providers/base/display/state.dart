part of 'bloc.dart';

@freezed
class DisplayState<T extends BaseModel, C> with _$DisplayState<T, C> {
  @override
  final Status status;
  @override
  final List<T> items;
  @override
  final C? cursor;
  @override
  final bool isEnd;
  @override
  final Failure? failure;

  DisplayState({
    this.status = Status.initial,
    this.items = const [],
    this.cursor,
    this.isEnd = false,
    this.failure,
  });
}

extension DisplayStateExtension<T extends BaseModel, C> on DisplayState<T, C> {
  bool get canFetchMore => !isEnd && status != Status.loading;
}
