part of '../diary_usecases.dart';

class _CreateDiaryEntryUseCase with FailureHandlerMixin {
  _CreateDiaryEntryUseCase(this._repository, {this.logger});

  final DiaryRepository _repository;
  final Logger? logger;

  Future<Either<Failure, DiaryEntity>> call({
    String? clientId,
    String? title,
    required String content,
    DiaryMood? mood,
    List<File> files = const [],
  }) async {
    const scope = '[Diary][Create]';
    logger?.useCaseTrace(scope, '요청 처리 시작 (files=${files.length})');

    final trimmedTitle = title?.trim();
    final trimmedContent = content.trimRight();

    if (trimmedTitle != null &&
        trimmedTitle.length > diaryEntryMaxTitleLength) {
      final failure = Failure.validation(
        '제목은 최대 $diaryEntryMaxTitleLength자까지 입력할 수 있습니다.',
      );
      logger?.useCaseFail(scope, failure, hint: '입력값 검증');
      return failure.toLeft();
    } else if (trimmedContent.trim().isEmpty) {
      final failure = Failure.validation('일기 내용을 입력해주세요.');
      logger?.useCaseFail(scope, failure, hint: '입력값 검증');
      return failure.toLeft();
    } else if (trimmedContent.length > diaryMaxContentLength) {
      final failure = Failure.validation(
        '일기 내용은 최대 $diaryMaxContentLength자까지 작성할 수 있습니다.',
      );
      logger?.useCaseFail(scope, failure, hint: '입력값 검증');
      return failure.toLeft();
    }

    final id = (clientId == null || clientId.trim().isEmpty)
        ? Uuid().v4()
        : clientId.trim();
    logger?.useCaseTrace(scope, '클라이언트 식별자 확정 ($id)');
    List<CreateDiaryMediaRequest> medias = [];

    if (files.isNotEmpty) {
      logger?.useCaseTrace(scope, '미디어 ${files.length}개 업로드 시작');
      final uploadResult = await _repository.uploadMediaFiles(
        diaryId: id,
        files: files,
      );
      final failure = uploadResult.fold<Failure?>(
        (error) {
          final failure = failureFromApiError(error);
          logger?.useCaseFail(scope, failure, hint: '미디어 업로드');
          return failure;
        },
        (uploaded) {
          medias = uploaded;
          logger?.useCaseTrace(scope, '미디어 업로드 성공 (${uploaded.length}개)');
          return null;
        },
      );
      if (failure != null) {
        return failure.toLeft();
      }
    } else {
      logger?.useCaseTrace(scope, '첨부된 미디어 없음');
    }

    logger?.useCaseTrace(scope, '일기 저장 시작');
    final result = await _repository.create(
      clientId: id,
      title: (trimmedTitle == null || trimmedTitle.isEmpty)
          ? null
          : trimmedTitle,
      content: trimmedContent,
      mood: mood ?? DiaryMood.none,
      medias: medias,
    );
    final mapped = mapApiResult(result);
    mapped.fold(
      (failure) => logger?.useCaseFail(scope, failure, hint: '저장'),
      (_) => logger?.useCaseSuccess(scope, '일기 저장 성공'),
    );
    return mapped;
  }
}
