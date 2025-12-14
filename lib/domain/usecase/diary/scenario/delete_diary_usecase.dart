part of '../diary_usecases.dart';

class _DeleteDiaryUseCase {
  final DiaryRepository _repository;

  _DeleteDiaryUseCase(this._repository);

  Future<AppResponse<void>> call(String diaryId) async {
    return await _repository
        .deleteDiary(diaryId)
        .then((res) => res.toAppResponse());
  }
}
