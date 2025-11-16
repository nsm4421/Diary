import 'dart:io';
import 'dart:math' as math;

import 'package:diary/core/error/constant/error_code.dart';
import 'package:diary/core/error/failure/failure.dart';
import 'package:diary/core/value_objects/status.dart';
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
        status: CreateDiaryStatus.editing,
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
      if (state.status != CreateDiaryStatus.editing) return;

      emit(
        state.copyWith(status: CreateDiaryStatus.submitting, errorMessage: ''),
      );

      await _diaryUseCases
          .create(
            title: state.title.trim(),
            content: state.content.trimRight(),
            files: state.medias,
          )
          .then(
            (res) => res.fold(
              (failure) => emit(
                state.copyWith(
                  status: CreateDiaryStatus.failure,
                  errorMessage: _failureMessage(failure),
                ),
              ),
              (r) async {
                await Future.delayed(Duration(seconds: 1));
                emit(
                  state.copyWith(
                    status: CreateDiaryStatus.success,
                    errorMessage: '',
                  ),
                );
              },
            ),
          );
    } catch (e) {
      debugPrint(e.toString());
      emit(
        state.copyWith(
          status: CreateDiaryStatus.failure,
          errorMessage: '일기를 저장하지 못했습니다. 잠시 후 다시 시도해주세요.',
        ),
      );
    }
  }

  void handleRest() {
    emit(state.copyWith(status: CreateDiaryStatus.editing, errorMessage: ''));
  }

  String _failureMessage(Failure failure) {
    return switch (failure.code) {
      ErrorCode.validation => failure.description,
      ErrorCode.storage => '첨부 파일을 처리하지 못했습니다. 다시 시도해주세요.',
      ErrorCode.network || ErrorCode.timeout => '네트워크 상태를 확인 후 다시 시도해주세요.',
      _ => failure.description,
    };
  }
}
