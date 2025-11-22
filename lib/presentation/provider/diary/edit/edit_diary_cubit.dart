import 'dart:io';
import 'dart:math' as math;

import 'package:diary/core/constant/error_code.dart';
import 'package:diary/core/constant/status.dart';
import 'package:diary/core/utils/app_logger.dart';
import 'package:diary/core/value_objects/domain/diary_mood.dart';
import 'package:diary/core/value_objects/error/failure.dart';
import 'package:diary/domain/entity/diary_detail_entity.dart';
import 'package:diary/domain/entity/diary_entity.dart';
import 'package:diary/domain/usecase/diary/diary_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

part 'edit_diary_state.dart';

part 'edit_diary_cubit.freezed.dart';

enum EditDiaryMode { create, modify }

@injectable
class EditDiaryCubit extends Cubit<EditDiaryState> with AppLoggerMixIn {
  late final String _diaryId;
  late DiaryDetailEntity _initialDiary;
  late final EditDiaryMode _editMode;
  static const int _maxMediaCount = 3;
  final DiaryUseCases _diaryUseCases;

  EditDiaryCubit(@factoryParam String? diaryId, this._diaryUseCases)
    : super(EditDiaryState()) {
    _editMode = diaryId == null ? EditDiaryMode.create : EditDiaryMode.modify;
    this._diaryId = diaryId ?? Uuid().v4();
  }

  EditDiaryMode get mode => _editMode;

  DiaryEntity get diary => _initialDiary.copyWith(
    title: state.title,
    content: state.content,
    mood: state.mood,
    updatedAt: DateTime.now(),
  );

  void init() async {
    if (_editMode == EditDiaryMode.modify) {
      await _diaryUseCases
          .getDetail(_diaryId)
          .then(
            (res) => res.fold(
              (failure) {
                emit(
                  state.copyWith(
                    status: EditDiaryStatus.failure,
                    errorMessage: failure.message,
                  ),
                );
              },
              (diary) {
                _initialDiary = diary;
                emit(
                  state.copyWith(
                    title: diary.title ?? '',
                    content: diary.content,
                    medias: (diary.medias ?? [])
                        .map((e) => e.absolutePath)
                        .map(File.new)
                        .toList(growable: false),
                    status: EditDiaryStatus.editing,
                    mood: diary.mood,
                  ),
                );
              },
            ),
          );
    } else {
      emit(state.copyWith(status: EditDiaryStatus.editing));
    }
  }

  void handleChange({
    String? title,
    String? content,
    List<File>? medias,
    DiaryMood? mood,
  }) {
    emit(
      state.copyWith(
        status: EditDiaryStatus.editing,
        title: title ?? state.title,
        content: content ?? state.content,
        medias: medias ?? state.medias,
        mood: mood ?? state.mood,
      ),
    );
  }

  void addMediaFiles(List<File> files) {
    if (files.isEmpty) {
      return;
    }
    final current = List<File>.from(state.medias);
    final remaining = math.max(0, _maxMediaCount - current.length);
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
    emit(state.copyWith(status: EditDiaryStatus.submitting));

    try {
      await (_editMode == EditDiaryMode.create
              ? _diaryUseCases.create.call(
                  clientId: _diaryId,
                  title: state.title,
                  content: state.content,
                  files: state.medias,
                  mood: state.mood,
                )
              : _diaryUseCases.update.call(
                  id: _diaryId,
                  title: state.title,
                  content: state.content,
                  mood: state.mood,
                ))
          .then(
            (res) => res.fold(
              (failure) {
                emit(
                  state.copyWith(
                    status: EditDiaryStatus.failure,
                    errorMessage: _failureMessage(failure),
                  ),
                );
              },
              (saved) {
                emit(
                  state.copyWith(
                    status: EditDiaryStatus.success,
                    errorMessage: '',
                  ),
                );
              },
            ),
          );
    } catch (e) {
      emit(
        state.copyWith(
          status: EditDiaryStatus.failure,
          errorMessage: '일기를 저장하지 못했습니다. 잠시 후 다시 시도해주세요.',
        ),
      );
    }
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
