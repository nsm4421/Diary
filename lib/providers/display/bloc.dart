import 'package:diary/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared/shared.dart';

part 'state.dart';

part 'event.dart';

part 'bloc.freezed.dart';

typedef DisplayFetchResult<T extends BaseModel, C> = ({
  List<T> items,
  C cursor,
  bool isEnd,
});

abstract class DisplayBloc<T extends BaseModel, C>
    extends Bloc<DisplayEvent, DisplayState<T, C>> {
  DisplayBloc() : super(DisplayState()) {
    on<DisplayRefreshEvent>(_onRefresh);
    on<DisplayFetchMoreEvent>(_onFetchMore);
  }

  @protected
  TaskEither<Failure, DisplayFetchResult<T, C>> fetch({C? cursor});

  Future<void> _onRefresh(
    DisplayRefreshEvent event,
    Emitter<DisplayState<T, C>> emit,
  ) async {
    if (state.status.isLoading) return;
    await callApi(emit, cursor: state.cursor, append: false);
  }

  Future<void> _onFetchMore(
    DisplayFetchMoreEvent event,
    Emitter<DisplayState<T, C>> emit,
  ) async {
    if (!state.canFetchMore) return;
    await callApi(emit, cursor: state.cursor, append: true);
  }

  Future<void> callApi(
    Emitter<DisplayState<T, C>> emit, {
    required C? cursor,
    required bool append,
  }) async {
    emit(state.copyWith(status: Status.loading, failure: null));
    try {
      (await fetch(cursor: cursor).run()).match(
        (failure) {
          emit(state.copyWith(status: Status.error, failure: failure));
        },
        (result) {
          final items = append
              ? [...state.items, ...result.items]
              : result.items;
          emit(
            state.copyWith(
              status: Status.success,
              items: items,
              cursor: result.cursor,
              isEnd: result.isEnd,
              failure: null,
            ),
          );
        },
      );
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: Status.error,
          failure: Failure(
            message: 'unknown error occurs on bloc',
            error: error,
            stackTrace: stackTrace,
          ),
        ),
      );
    }
  }
}
