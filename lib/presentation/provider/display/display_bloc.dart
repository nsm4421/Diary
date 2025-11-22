import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:diary/core/constant/error_code.dart';
import 'package:diary/core/value_objects/error/failure.dart';
import 'package:diary/core/value_objects/pageable.dart';
import 'package:diary/core/constant/status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'display_state.dart';

part 'display_event.dart';

part 'display_bloc.freezed.dart';

// E : Entity, C : cursor data type, P : param type
abstract class DisplayBloc<E, C>
    extends Bloc<DisplayEvent<E>, DisplayState<E, C>> {
  final int pageSize;
  final bool prependOnUpsert;

  DisplayBloc({this.pageSize = 20, this.prependOnUpsert = true})
    : super(DisplayState<E, C>()) {
    on<_Started<E>>(_onStarted, transformer: restartable());
    on<_Refreshed<E>>(_onRefreshed, transformer: restartable());
    on<_NextPageRequested<E>>(_onNextPageRequested, transformer: droppable());
    on<_Upserted<E>>(_onUpserted);
    on<_Removed<E>>(_onRemoved);
  }

  @protected
  Future<Either<Failure, Pageable<E, C>>> fetch({
    required C cursor,
    int limit = 30,
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
            errorMessage: _failureMessage(failure),
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
            errorMessage: _failureMessage(failure),
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
            errorMessage: _failureMessage(failure),
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

  void _onUpserted(_Upserted<E> event, Emitter<DisplayState<E, C>> emit) {
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

  String _failureMessage(Failure failure) {
    return switch (failure.code) {
      ErrorCode.badRequest => '잘못된 요청입니다.',
      ErrorCode.unauthorized => '인증이 필요합니다.',
      ErrorCode.forbidden => '접근 권한이 없습니다.',
      ErrorCode.notFound => '요청한 데이터를 찾을 수 없습니다.',
      ErrorCode.conflict => '이미 처리된 요청입니다.',
      ErrorCode.server => '데이터를 불러오는 중 문제가 발생했습니다. 잠시 후 다시 시도해주세요.',
      ErrorCode.network => '네트워크 연결을 확인해주세요.',
      ErrorCode.timeout => '요청 시간이 초과되었습니다. 잠시 후 다시 시도해주세요.',
      ErrorCode.cache || ErrorCode.database => '저장된 데이터를 불러오는 중 문제가 발생했습니다.',
      ErrorCode.storage => '파일을 처리하는 중 문제가 발생했습니다.',
      ErrorCode.parsing => '데이터 처리 중 오류가 발생했습니다.',
      ErrorCode.validation => failure.description,
      ErrorCode.cancelled => '요청이 취소되었습니다.',
      ErrorCode.unknown => '알 수 없는 오류가 발생했습니다.',
    };
  }
}
