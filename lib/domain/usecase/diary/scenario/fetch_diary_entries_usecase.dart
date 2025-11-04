part of '../diary_usecases.dart';

enum _SearchField { none, title }

class FetchDiaryParam {
  final _SearchField field;
  final String keyword;

  FetchDiaryParam({this.field = _SearchField.none, required this.keyword});

  factory FetchDiaryParam.none() {
    return FetchDiaryParam(field: _SearchField.none, keyword: '');
  }

  factory FetchDiaryParam.title(String title) {
    return FetchDiaryParam(field: _SearchField.title, keyword: title);
  }

  @override
  String toString() {
    return 'field:${field.name}|keyword:$keyword';
  }
}

class _FetchDiaryEntriesUseCase {
  _FetchDiaryEntriesUseCase(this._repository);

  final DiaryRepository _repository;

  Future<Either<Failure, Pageable<DiaryEntity, DateTime>>> call({
    int limit = 20,
    required DateTime cursor,
    required FetchDiaryParam param,
  }) async {
    if (limit <= 0) {
      return Failure.validation('조회 개수는 1 이상이어야 합니다.').toLeft();
    }
    debugPrint(param.toString());
    
    final action = switch (param.field) {
      _SearchField.none => _repository.fetchEntries(
        limit: limit,
        cursor: cursor,
      ),
      _SearchField.title => _repository.searchByTitle(
        limit: limit,
        cursor: cursor,
        keyword: param.keyword,
      ),
    };

    return await action.then(
      (res) => res.fold(
        (l) => l.withFriendlyMessage().toLeft(),
        (r) {
          debugPrint('${r.length} diaries fetched');
          return Right(
          r.isEmpty
              ? Pageable<DiaryEntity, DateTime>.empty()
              : Pageable<DiaryEntity, DateTime>(
                  items: r,
                  nextCursor: r
                      .map((e) => e.createdAt)
                      .reduce((v, e) => v.isAfter(e) ? e : v),
                ),
        );
        },
      ),
    );
  }
}
