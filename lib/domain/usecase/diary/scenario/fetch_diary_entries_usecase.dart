part of '../diary_usecases.dart';

class _FetchDiariesUseCase {
  _FetchDiariesUseCase(this._repository);

  final DiaryRepository _repository;

  Future<Either<Failure, Pageable<DiaryEntity, DateTime>>> call({
    int limit = 20,
    required DateTime cursor,
    FetchDiaryParam? param,
  }) async {
    if (limit <= 0) {
      return Failure.validation('조회 개수는 1 이상이어야 합니다.').toLeft();
    }

    final effectiveParam = param ?? FetchDiaryParam.none();
    final action = switch (effectiveParam.kind) {
      SearchDiaryKind.none => _repository.fetchDiaries(
        limit: limit,
        cursor: cursor,
      ),
      SearchDiaryKind.title => _repository.searchByTitle(
        limit: limit,
        cursor: cursor,
        keyword: (effectiveParam as FetchDiaryByTitleParamValue).title,
      ),
      SearchDiaryKind.content => _repository.searchByTitle(
        limit: limit,
        cursor: cursor,
        keyword: (effectiveParam as FetchDiaryByContentParamValue).content,
      ),
      SearchDiaryKind.dateRange => _repository.searchByDateRange(
        limit: limit,
        cursor: cursor,
        start: (effectiveParam as FetchDiaryByDateRangeParamValue).start,
        end: (effectiveParam).end,
      ),
    };

    return await action.then(
      (res) => res.fold(
        (failure) => failure.withFriendlyMessage().toLeft(),
        (entities) => Right(
          entities.isEmpty
              ? Pageable<DiaryEntity, DateTime>.empty()
              : Pageable<DiaryEntity, DateTime>.from(
                  entities,
                  cursorCallback: (entities) => entities
                      .map((e) => e.createdAt)
                      .reduce((prev, curr) => prev.isAfter(curr) ? curr : prev),
                ),
        ),
      ),
    );
  }
}
