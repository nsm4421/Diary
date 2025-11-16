part of 'display_bloc.dart';

// E : entity, C : cursor data type
@freezed
class DisplayState<E, C> with _$DisplayState<E, C> {
  DisplayState({
    this.status = DisplayStatus.initial,
    this.items = const [],
    this.nextCursor,
    this.errorMessage,
  });

  final DisplayStatus status;
  final List<E> items;
  final C? nextCursor;
  final String? errorMessage;

  bool get isEmpty => items.isEmpty && errorMessage == null;

  bool get isEnd => nextCursor == null;
}
