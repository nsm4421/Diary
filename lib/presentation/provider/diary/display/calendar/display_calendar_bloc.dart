import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:diary/core/constant/error_code.dart';
import 'package:diary/core/constant/status.dart';
import 'package:diary/core/extension/datetime_extension.dart';
import 'package:diary/core/value_objects/error/failure.dart';
import 'package:diary/domain/entity/diary_entity.dart';
import 'package:diary/domain/usecase/diary/diary_usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'display_calendar_state.dart';

part 'display_calendar_event.dart';

part 'display_calendar_bloc.freezed.dart';

@injectable
class DisplayCalendarBloc
    extends Bloc<DisplayCalendarEvent, DisplayCalendarState> {
  DisplayCalendarBloc(this._diaryUseCases) : super(DisplayCalendarState()) {
    on<_Started>(_onStarted, transformer: restartable());
    on<_Refreshed>(_onRefreshed, transformer: droppable());
    on<_CurrentChanged>(_onCurrentChanged, transformer: droppable());
    on<_MonthChanged>(_onMonthChanged, transformer: droppable());
  }

  final DiaryUseCases _diaryUseCases;

  Future<void> _onStarted(
    _Started event,
    Emitter<DisplayCalendarState> emit,
  ) async {
    debugPrint('[DisplayCalendarBloc] _onStarted called');
    await _loadDiaries(state.normalizedMonth, emit);
  }

  Future<void> _onRefreshed(
    _Refreshed event,
    Emitter<DisplayCalendarState> emit,
  ) async {
    await _loadDiaries(state.normalizedMonth, emit);
  }

  Future<void> _onCurrentChanged(
    _CurrentChanged event,
    Emitter<DisplayCalendarState> emit,
  ) async {
    final shouldUpdateMonth =
        event.currentDate.normalizedMonth != state.normalizedMonth;
    if (shouldUpdateMonth) {
      await _loadDiaries(event.currentDate, emit).then((isSuccess) {
        if (isSuccess) {
          emit(state.copyWith(currentDate: event.currentDate));
        }
      });
    } else {
      emit(state.copyWith(currentDate: event.currentDate));
    }
  }

  Future<void> _onMonthChanged(
    _MonthChanged event,
    Emitter<DisplayCalendarState> emit,
  ) async {
    if (event.targetDate.normalizedMonth == state.normalizedMonth) {
      return;
    }
    await _loadDiaries(event.targetDate, emit);
  }

  Future<bool> _loadDiaries(
    DateTime targetDate,
    Emitter<DisplayCalendarState> emit,
  ) async {
    emit(
      state.copyWith(
        status: DisplayCalendarStatus.loading,
        targetDate: targetDate,
        diaries: [],
        errorMessage: '',
      ),
    );
    final res = await _diaryUseCases.findAllByMonth(state.normalizedMonth);
    res.fold(
      (failure) {
        emit(
          state.copyWith(
            status: DisplayCalendarStatus.failure,
            errorMessage: _failureMessage(failure),
          ),
        );
      },
      (diaries) {
        emit(
          state.copyWith(
            status: DisplayCalendarStatus.fetched,
            diaries: diaries,
          ),
        );
      },
    );
    return res.isRight();
  }

  String _failureMessage(Failure failure) {
    return switch (failure.code) {
      ErrorCode.validation => failure.description,
      ErrorCode.notFound => '선택한 월의 일기를 찾을 수 없어요.',
      _ => '일기를 불러오는 중 문제가 발생했습니다.',
    };
  }
}
