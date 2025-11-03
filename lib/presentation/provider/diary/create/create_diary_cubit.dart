import 'dart:io';
import 'dart:math' as math;

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

  void handleChange({String? title, String? content, List<File>? medias}) {
    emit(
      state.copyWith(
        status: _Status.editing,
        title: title ?? state.title,
        content: content ?? state.content,
        medias: medias ?? state.medias,
      ),
    );
  }

  void addMediaFiles(List<File> files) {
    if (files.isEmpty) {
      return;
    }
    final current = List<File>.from(state.medias);
    final remaining = math.max(0, 3 - current.length);
    if (remaining <= 0) {
      return;
    }
    current.addAll(files.take(remaining));
    handleChange(medias: List<File>.unmodifiable(current));
  }

  void removeMediaAt(int index) {
    if (index < 0 || index >= state.medias.length) {
      return;
    }
    final current = List<File>.from(state.medias)..removeAt(index);
    handleChange(medias: List<File>.unmodifiable(current));
  }

  void clearMedias() {
    if (state.medias.isEmpty) return;
    handleChange(medias: const []);
  }

  Future<void> handleSubmit() async {
    try {
      if (state.status != _Status.editing) return;

      emit(state.copyWith(status: _Status.submitting));

      await _diaryUseCases
          .create(
            title: state.title.trim(),
            content: state.content.trimRight(),
            files: state.medias,
          )
          .then(
            (res) => res.fold(
              (l) => emit(state.copyWith(status: _Status.failure, failure: l)),
              (r) async {
                await Future.delayed(Duration(seconds: 1));
                emit(state.copyWith(status: _Status.success, failure: null));
              },
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
