part of '../diary_usecases.dart';

class _FetchDiariesUseCase {
  final DiaryRepository _repository;

  _FetchDiariesUseCase(this._repository);

  Future<AppResponse<List<DiaryEntity>>> call({
    DateTime? lastCreatedAt,
    int limit = 20,
  }) async {
    // TODO : story media와 join한 데이터 가져오기
    return await _repository
        .fetchDiaries(
          cursor: (lastCreatedAt ?? DateTime.now()).toUtc().toIso8601String(),
          limit: limit,
        )
        .then((res) => res.map((e) => e.toList()))
        .then((res) => res.toAppResponse());
  }
}
