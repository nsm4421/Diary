part of '../diary_usecases.dart';

class _CreateDiaryUseCase {
  final DiaryRepository _repository;

  _CreateDiaryUseCase(this._repository);

  Future<AppResponse<DiaryEntity>> call({
    String? diaryId,
    String? title,
  }) async {
    return await _repository
        .insertDiary(clientDiaryId: diaryId, title: title)
        .then((res) => res.toAppResponse());
  }
}
