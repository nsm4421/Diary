part of '../diary_usecases.dart';

class _DeleteDiaryEntryUseCase with FailureHandlerMixin {
  _DeleteDiaryEntryUseCase(this._repository, {this.logger});

  final DiaryRepository _repository;
  final Logger? logger;
  static const _scope = '[Diary][Delete]';

  Future<Either<Failure, void>> call(String id) async {
    final trimmedId = id.trim();
    logger?.useCaseTrace(_scope, '삭제 요청 수신 (id=$trimmedId)');
    if (trimmedId.isEmpty) {
      final failure = Failure.validation('일기 식별자가 올바르지 않습니다.');
      logger?.useCaseFail(_scope, failure, hint: '입력값 검증');
      return failure.toLeft();
    }

    logger?.useCaseTrace(_scope, '저장소 삭제 호출');
    final result = await _repository.delete(trimmedId).then(mapApiResult);
    result.fold(
      (failure) => logger?.useCaseFail(_scope, failure, hint: '삭제'),
      (_) => logger?.useCaseSuccess(_scope, '삭제 성공'),
    );
    return result;
  }
}
