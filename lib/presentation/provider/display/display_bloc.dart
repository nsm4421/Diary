import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:diary/core/error/failure.dart';
import 'package:diary/core/value_objects/pageable.dart';
import 'package:diary/core/value_objects/status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'display_state.dart';
part 'display_event.dart';
part 'display_bloc.freezed.dart';

// E : Entity, C : cursor data type, P : param type
abstract class DisplayBloc<E, C, P>
    extends Bloc<DisplayEvent<E, P>, DisplayState<E, C>> {
  final int pageSize;
  final bool prependOnUpsert;

  DisplayBloc({this.pageSize = 20, this.prependOnUpsert = true})
    : super(DisplayState<E, C>()) {
    on<_Started<E, P>>(_onStarted, transformer: restartable());
    on<_Refreshed<E, P>>(_onRefreshed, transformer: restartable());
    on<_NextPageRequested<E, P>>(_onNextPageRequested, transformer: droppable());
    on<_Upserted<E, P>>(_onUpserted);
    on<_Removed<E, P>>(_onRemoved);
  }

  @protected
  Future<Either<Failure, Pageable<E,C>>> fetch({
    required C cursor,
    int limit = 30,
    P? param
  });

  @protected
  String idOf(E item);

  @protected
  C initialCursor();

  @protected
  List<E> reorderAfterUpsert(List<E> current, E upserted) {
    final filtered = current
        .where((e) => idOf(e) != idOf(upserted))
        .toList(growable: true);
    if (prependOnUpsert) {
      filtered.insert(0, upserted);
      return filtered;
    }
    filtered.add(upserted);
    return filtered;
  }

  Future<void> _onStarted(
    _Started<E, P> event,
    Emitter<DisplayState<E,C>> emit,
  ) async {
    emit(state.copyWith(status: DisplayStatus.loading, failure: null));
    await fetch(cursor: initialCursor(), limit: pageSize).then(
      (res) => res.fold(
        (failure) => emit(
          state.copyWith(
            status: DisplayStatus.initial,
            failure: failure,
            items: const [],
            nextCursor: null,
          ),
        ),
        (page) => emit(
          state.copyWith(
            status: DisplayStatus.paginated,
            failure: null,
            items: page.items,
            nextCursor: page.nextCursor,
          ),
        ),
      ),
    );
  }

  Future<void> _onRefreshed(
    _Refreshed<E, P> event,
    Emitter<DisplayState<E,C>> emit,
  ) async {
    emit(state.copyWith(status: DisplayStatus.refreshing, failure: null));
    await fetch(cursor: initialCursor(), limit: pageSize).then(
      (res) => res.fold(
        (failure) => emit(
          state.copyWith(status: DisplayStatus.initial, failure: failure),
        ),
        (page) => emit(
          state.copyWith(
            status: DisplayStatus.paginated,
            failure: null,
            items: page.items,
            nextCursor: page.nextCursor,
          ),
        ),
      ),
    );
  }

  Future<void> _onNextPageRequested(
    _NextPageRequested<E, P> event,
    Emitter<DisplayState<E,C>> emit,
  ) async {
    if (state.isEnd ||
        state.status == DisplayStatus.loading ||
        state.status == DisplayStatus.refreshing ||
        state.status == DisplayStatus.paginated) {
      return;
    }

    emit(state.copyWith(status: DisplayStatus.paginated, failure: null));

    await fetch(
      cursor: state.nextCursor ?? initialCursor(),
      limit: pageSize,
    ).then(
      (res) => res.fold(
        (failure) => emit(
          state.copyWith(status: DisplayStatus.initial, failure: failure),
        ),
        (page) {
          final merged = _mergeAppendUniqueById(state.items, page.items);
          emit(
            state.copyWith(
              status: DisplayStatus.initial,
              failure: null,
              items: merged,
              nextCursor: page.nextCursor,
            ),
          );
        },
      ),
    );
  }

  void _onUpserted(_Upserted<E, P> event, Emitter<DisplayState<E,C>> emit) {
    emit(state.copyWith(items: reorderAfterUpsert(state.items, event.item)));
  }

  void _onRemoved(_Removed<E, P> event, Emitter<DisplayState<E,C>> emit) {
    emit(
      state.copyWith(
        items: state.items
            .where((e) => idOf(e) != event.id)
            .toList(growable: false),
      ),
    );
  }

  List<E> _mergeAppendUniqueById(List<E> current, List<E> incoming) {
    if (incoming.isEmpty) return current;
    final existingIds = {for (final e in current) idOf(e)};
    final toAppend = incoming.where((e) => !existingIds.contains(idOf(e)));
    return List<E>.from(current)..addAll(toAppend);
  }
}
