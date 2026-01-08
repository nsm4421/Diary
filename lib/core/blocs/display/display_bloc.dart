import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../value_objects/failure.dart';

part 'display_state.dart';

part 'display_event.dart';

part 'display_bloc.freezed.dart';

abstract class DisplayBloc<E, C>
    extends Bloc<DisplayEvent<E>, DisplayState<E>> {
  final int pageSize;

  DisplayBloc({this.pageSize = 20}) : super(DisplayState<E>.idle()) {
    on<_Started<E>>(_onStarted, transformer: restartable());
    on<_NextPageRequested<E>>(_onNextPageRequested, transformer: droppable());
    on<_Updated<E>>(_onUpdated, transformer: droppable());
    on<_Append<E>>(_onAppend, transformer: droppable());
    on<_Removed<E>>(_onRemoved, transformer: droppable());
  }

  @protected
  TaskEither<Failure, List<E>> fetch({required C cursor, int limit = 20});

  @protected
  String idOf(E item);

  @protected
  C getCursor([List<E>? items]);

  Future<void> _onStarted(
    _Started<E> event,
    Emitter<DisplayState<E>> emit,
  ) async {
    emit(DisplayState.idle());
    (await fetch(cursor: getCursor([]), limit: pageSize).run()).match(
      (failure) => emit(_Failure(items: [], failure: failure)),
      (fetched) => emit(
        fetched.length < pageSize ? _PageEnd(fetched) : _Paginated(fetched),
      ),
    );
  }

  Future<void> _onNextPageRequested(
    _NextPageRequested<E> event,
    Emitter<DisplayState<E>> emit,
  ) async {
    if (!state.canRequestNextPage) return;
    (await fetch(cursor: getCursor(state.items), limit: pageSize).run()).match(
      (failure) => emit(_Failure(items: state.items, failure: failure)),
      (fetched) {
        final items = [...state.items, ...fetched];
        emit(fetched.length < pageSize ? _PageEnd(items) : _Paginated(items));
      },
    );
  }

  Future<void> _onAppend(
    _Append<E> event,
    Emitter<DisplayState<E>> emit,
  ) async {
    final appended = [...state.items, event.item];
    state.when(
      idle: () => emit(_Idle()),
      loading: (_) => emit(_Loading(appended)),
      paginated: (_) => emit(_Paginated(appended)),
      pageEnd: (_) => emit(_PageEnd(appended)),
      failure: (_, failure) =>
          emit(_Failure(items: appended, failure: failure)),
    );
  }

  Future<void> _onUpdated(
    _Updated<E> event,
    Emitter<DisplayState<E>> emit,
  ) async {
    final updated = state.items
        .map((e) => idOf(e) == idOf(event.item) ? event.item : e)
        .toList(growable: false);
    state.when(
      idle: () => emit(_Idle()),
      loading: (_) => emit(_Loading(updated)),
      paginated: (_) => emit(_Paginated(updated)),
      pageEnd: (_) => emit(_PageEnd(updated)),
      failure: (_, failure) => emit(_Failure(items: updated, failure: failure)),
    );
  }

  Future<void> _onRemoved(
    _Removed<E> event,
    Emitter<DisplayState<E>> emit,
  ) async {
    final removed = state.items
        .where((e) => idOf(e) != event.id)
        .toList(growable: false);
    state.when(
      idle: () => emit(_Idle()),
      loading: (_) => emit(_Loading(removed)),
      paginated: (_) => emit(_Paginated(removed)),
      pageEnd: (_) => emit(_PageEnd(removed)),
      failure: (_, failure) => emit(_Failure(items: removed, failure: failure)),
    );
  }
}
