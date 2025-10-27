part of '../diary_usecases.dart';

class _SearchDiaryEntriesUseCase {
  _SearchDiaryEntriesUseCase(this._repository);

  final DiaryRepository _repository;

  Future<Either<Failure, List<DiaryEntry>>> call({
    required String keyword,
    int limit = 20,
    int offset = 0,
  }) async {
    if (keyword.trim().isEmpty) {
      return Failure.validation('검색어를 입력해주세요.').toLeft();
    } else if (limit <= 0) {
      return Failure.validation('조회 개수는 1 이상이어야 합니다.').toLeft();
    } else if (offset < 0) {
      return Failure.validation('조회 시작 위치는 0 이상이어야 합니다.').toLeft();
    }

    return await _repository
        .searchByTitle(keyword: keyword.trim(), limit: limit, offset: offset)
        .then(
          (res) => res.fold((l) => l.withFriendlyMessage().toLeft(), Right.new),
        );
  }
}
