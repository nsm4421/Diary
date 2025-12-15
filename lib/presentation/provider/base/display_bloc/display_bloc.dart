import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:diary/core/constant/status.dart';
import 'package:diary/core/response/app_response.dart';
import 'package:diary/core/value_objects/pageable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'display_state.dart';

part 'display_event.dart';

part 'display_bloc.freezed.dart';

// E : Entity, C : cursor data type
abstract class DisplayBloc<E, C>
    extends Bloc<DisplayEvent<E>, DisplayState<E, C>> {
  final int pageSize;

  DisplayBloc({this.pageSize = 20}) : super(DisplayState<E, C>()) {
    on<_Started<E>>(_onStarted, transformer: restartable());
    on<_Refreshed<E>>(_onRefreshed, transformer: restartable());
    on<_NextPageRequested<E>>(_onNextPageRequested, transformer: droppable());
    on<_Updated<E>>(_onUpdated);
    on<_Created<E>>(_onCreated);
    on<_Removed<E>>(_onRemoved);
  }

  @protected
  Future<AppResponse<Pageable<E, C>>> fetch({
    required C cursor,
    int limit = 20,
  });

  @protected
  String idOf(E item);

  @protected
  C initialCursor();

  Future<void> _onStarted(
    _Started<E> event,
    Emitter<DisplayState<E, C>> emit,
  ) async {
    emit(state.copyWith(status: DisplayStatus.loading, errorMessage: null));
    await fetch(cursor: initialCursor(), limit: pageSize).then(
      (res) => res.fold(
        (failure) => emit(
          state.copyWith(
            status: DisplayStatus.initial,
            errorMessage: failure.message,
            items: const [],
            nextCursor: null,
          ),
        ),
        (page) => emit(
          state.copyWith(
            status: DisplayStatus.initial,
            errorMessage: null,
            items: page.items,
            nextCursor: page.nextCursor,
          ),
        ),
      ),
    );
  }

  Future<void> _onRefreshed(
    _Refreshed<E> event,
    Emitter<DisplayState<E, C>> emit,
  ) async {
    emit(state.copyWith(status: DisplayStatus.refreshing, errorMessage: null));
    await fetch(cursor: initialCursor(), limit: pageSize).then(
      (res) => res.fold(
        (failure) => emit(
          state.copyWith(
            status: DisplayStatus.initial,
            errorMessage: failure.message,
          ),
        ),
        (page) => emit(
          state.copyWith(
            status: DisplayStatus.initial,
            errorMessage: null,
            items: page.items,
            nextCursor: page.nextCursor,
          ),
        ),
      ),
    );
  }

  Future<void> _onNextPageRequested(
    _NextPageRequested<E> event,
    Emitter<DisplayState<E, C>> emit,
  ) async {
    if (state.isEnd ||
        state.status == DisplayStatus.loading ||
        state.status == DisplayStatus.refreshing ||
        state.status == DisplayStatus.paginated) {
      return;
    }

    emit(state.copyWith(status: DisplayStatus.paginated, errorMessage: null));

    await fetch(
      cursor: state.nextCursor ?? initialCursor(),
      limit: pageSize,
    ).then(
      (res) => res.fold(
        (failure) => emit(
          state.copyWith(
            status: DisplayStatus.initial,
            errorMessage: failure.message,
          ),
        ),
        (page) {
          final merged = _mergeAppendUniqueById(state.items, page.items);
          emit(
            state.copyWith(
              status: DisplayStatus.initial,
              errorMessage: null,
              items: merged,
              nextCursor: page.nextCursor,
            ),
          );
        },
      ),
    );
  }

  void _onCreated(_Created<E> event, Emitter<DisplayState<E, C>> emit) {
    emit(
      state.copyWith(
        items: [event.item, ...state.items].toList(growable: false),
      ),
    );
  }

  void _onUpdated(_Updated<E> event, Emitter<DisplayState<E, C>> emit) {
    emit(
      state.copyWith(
        items: state.items
            .map((e) => idOf(e) == idOf(event.item) ? event.item : e)
            .toList(growable: false),
      ),
    );
  }

  void _onRemoved(_Removed<E> event, Emitter<DisplayState<E, C>> emit) {
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
