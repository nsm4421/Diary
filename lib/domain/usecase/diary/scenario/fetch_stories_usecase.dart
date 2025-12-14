part of '../diary_usecases.dart';

class _FetchStoriesUseCase {
  final DiaryRepository _repository;

  _FetchStoriesUseCase(this._repository);

  Future<AppResponse<List<StoryEntity>>> call({
    required String diaryId,
    DateTime? lastCreatedAt,
    int limit = 20,
  }) async {
    return await _repository
        .fetchStories(
          diaryId: diaryId,
          cursor: (lastCreatedAt ?? DateTime.now()).toUtc().toIso8601String(),
          limit: limit,
        )
        .then((res) => res.toAppResponse());
  }
}
