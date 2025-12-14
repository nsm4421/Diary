part of '../diary_usecases.dart';

class _DeleteStoryUseCase {
  final DiaryRepository _repository;

  _DeleteStoryUseCase(this._repository);

  Future<AppResponse<void>> call(String storyId) async {
    return await _repository
        .deleteStory(storyId)
        .then((res) => res.toAppResponse());
  }
}
