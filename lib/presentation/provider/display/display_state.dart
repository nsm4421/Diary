part of 'display_bloc.dart';

// E : entity, C : cursor data type
@freezed
class DisplayState<E, C> with _$DisplayState<E, C> {
  DisplayState({
    this.status = DisplayStatus.initial,
    this.items = const [],
    this.nextCursor,
    this.failure,
  });

  final DisplayStatus status;
  final List<E> items;
  final C? nextCursor;
  final Failure? failure;

  bool get isEmpty => items.isEmpty && failure == null;

  bool get isEnd => nextCursor == null;
}
