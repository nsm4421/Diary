part of '../diary_usecases.dart';

class _GetDiaryDetailUseCase with FailureHandlerMixin {
  _GetDiaryDetailUseCase(this._repository, {this.logger});

  final DiaryRepository _repository;
  final Logger? logger;
  static const _scope = '[Diary][Detail]';

  Future<Either<Failure, DiaryDetailEntity?>> call(String id) async {
    final trimmedId = id.trim();
    logger?.useCaseTrace(_scope, '상세 조회 요청 수신 (id=$trimmedId)');
    if (trimmedId.isEmpty) {
      final failure = Failure.validation('일기 식별자가 올바르지 않습니다.');
      logger?.useCaseFail(_scope, failure, hint: '입력값 검증');
      return failure.toLeft();
    }

    logger?.useCaseTrace(_scope, '저장소 상세 조회 실행');
    final result = await _repository
        .getDiaryDetail(trimmedId)
        .then(mapApiResult);
    result.fold(
      (failure) => logger?.useCaseFail(_scope, failure, hint: '상세 조회'),
      (entity) => logger?.useCaseSuccess(
        _scope,
        entity == null ? '조회 성공 - 결과 없음' : '조회 성공 - ${entity.id}',
      ),
    );
    return result;
  }
}
