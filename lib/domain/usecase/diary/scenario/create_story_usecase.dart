part of '../diary_usecases.dart';

class _CreateStoryUseCase {
  final DiaryRepository _repository;

  _CreateStoryUseCase(this._repository);

  Future<AppResponse<StoryEntity>> call({
    required String diaryId,
    int sequence = 0,
    required String description,
  }) async {
    final storyId = genUuid();
    return await _repository
        .insertStory(
          diaryId: diaryId,
          clientStoryId: storyId,
          sequence: sequence,
          description: description,
        )
        .then((res) => res.toAppResponse());
  }
}
