part of '../diary_usecases.dart';

class _UpdateDiaryEntryUseCase with FailureHandlerMixin {
  _UpdateDiaryEntryUseCase(this._repository, {this.logger});

  final DiaryRepository _repository;
  final Logger? logger;
  static const _scope = '[Diary][Update]';

  Future<Either<Failure, DiaryEntity>> call({
    required String id,
    String? title,
    required String content,
  }) async {
    final trimmedId = id.trim();
    final trimmedTitle = title?.trim();
    final trimmedContent = content.trimRight();
    logger?.useCaseTrace(
      _scope,
      '수정 요청 수신 (id=$trimmedId, hasTitle=${trimmedTitle?.isNotEmpty == true})',
    );

    if (trimmedId.isEmpty) {
      final failure = Failure.validation('일기 식별자가 올바르지 않습니다.');
      logger?.useCaseFail(_scope, failure, hint: '입력값 검증');
      return failure.toLeft();
    } else if (trimmedContent.trim().isEmpty) {
      final failure = Failure.validation('일기 내용을 입력해주세요.');
      logger?.useCaseFail(_scope, failure, hint: '입력값 검증');
      return failure.toLeft();
    } else if (trimmedContent.length > kDiaryEntryMaxContentLength) {
      final failure = Failure.validation(
        '일기 내용은 최대 $kDiaryEntryMaxContentLength자까지 작성할 수 있습니다.',
      );
      logger?.useCaseFail(_scope, failure, hint: '입력값 검증');
      return failure.toLeft();
    }

    logger?.useCaseTrace(_scope, '저장소 수정 호출');
    final result = await _repository
        .update(
          diaryId: trimmedId,
          title: (trimmedTitle == null || trimmedTitle.isEmpty)
              ? null
              : trimmedTitle,
          content: trimmedContent,
        )
        .then(mapApiResult);
    result.fold(
      (failure) => logger?.useCaseFail(_scope, failure, hint: '수정'),
      (diary) => logger?.useCaseSuccess(_scope, '수정 성공'),
    );
    return result;
  }
}
