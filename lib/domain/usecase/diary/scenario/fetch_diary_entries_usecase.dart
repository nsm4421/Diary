part of '../diary_usecases.dart';

class _FetchDiaryEntriesUseCase {
  _FetchDiaryEntriesUseCase(this._repository);

  final DiaryRepository _repository;

  Future<Either<Failure, List<DiaryEntry>>> call({
    int limit = 20,
    int offset = 0,
  }) async {
    if (limit <= 0) {
      return Failure.validation('조회 개수는 1 이상이어야 합니다.').toLeft();
    } else if (offset < 0) {
      return Failure.validation('조회 시작 위치는 0 이상이어야 합니다.').toLeft();
    }

    return await _repository
        .fetchEntries(limit: limit, offset: offset)
        .then(
          (res) => res.fold((l) => l.withFriendlyMessage().toLeft(), Right.new),
        );
  }
}
