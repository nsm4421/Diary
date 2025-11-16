part of '../diary_usecases.dart';

class _FetchDiariesUseCase with FailureHandlerMixin {
  _FetchDiariesUseCase(this._repository, {this.logger});

  final DiaryRepository _repository;
  final Logger? logger;
  static const _scope = '[Diary][Fetch]';

  Future<Either<Failure, Pageable<DiaryEntity, DateTime>>> call({
    int limit = 20,
    required DateTime cursor,
    FetchDiaryParam? param,
  }) async {
    logger?.useCaseTrace(_scope, '조회 시작 (limit=$limit, cursor=$cursor)');
    if (limit <= 0) {
      final failure = Failure.validation(
        '조회 개수는 1 이상이어야 합니다.',
      );
      logger?.useCaseFail(_scope, failure, hint: '입력값 검증');
      return failure.toLeft();
    }

    final effectiveParam = param ?? FetchDiaryParam.none();
    logger?.useCaseTrace(_scope, '검색 조건=${effectiveParam.kind}');
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

    logger?.useCaseTrace(_scope, '저장소 조회 실행');
    final result = await action.then(mapApiResult);
    return result.fold(
      (failure) {
        logger?.useCaseFail(_scope, failure, hint: '조회');
        return failure.toLeft();
      },
      (entities) {
        if (entities.isEmpty) {
          logger?.useCaseTrace(_scope, '조회 성공 - 빈 결과');
          return Right(Pageable<DiaryEntity, DateTime>.empty());
        }

        final pageable = Pageable<DiaryEntity, DateTime>.from(
          entities,
          cursorCallback: (items) => items
              .map((e) => e.createdAt)
              .reduce((prev, curr) => prev.isAfter(curr) ? curr : prev),
        );
        logger?.useCaseSuccess(
          _scope,
          '조회 성공 - ${pageable.items.length}건 반환',
        );
        return Right(pageable);
      },
    );
  }
}
