import 'package:diary/core/error/failure.dart';
import 'package:diary/domain/usecase/diary/diary_usecases.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'create_diary_state.dart';
part 'create_diary_cubit.freezed.dart';

@injectable
class CreateDiaryCubit extends Cubit<CreateDiaryState> {
  final DiaryUseCases _diaryUseCases;
  CreateDiaryCubit(this._diaryUseCases) : super(CreateDiaryState());

  void handleChange({String? title, String? content}) {
    emit(
      state.copyWith(
        status: _Status.editing,
        title: title ?? state.title,
        content: content ?? state.content,
      ),
    );
  }

  Future<void> handleSubmit() async {
    try {
      if (state.status != _Status.editing) return;

      emit(state.copyWith(status: _Status.submitting));

      await _diaryUseCases
          .create(title: state.title.trim(), content: state.content.trimRight())
          .then(
            (res) => res.fold(
              (l) => emit(state.copyWith(status: _Status.failure, failure: l)),
              (r) =>
                  emit(state.copyWith(status: _Status.success, failure: null)),
            ),
          );
    } catch (e) {
      debugPrint(e.toString());
      emit(
        state.copyWith(
          status: _Status.failure,
          failure: Failure.unknown(message: '알수 없는 오류가 발생했습니다'),
        ),
      );
    }
  }

  void handleRest() {
    emit(state.copyWith(status: _Status.editing, failure: null));
  }
}
