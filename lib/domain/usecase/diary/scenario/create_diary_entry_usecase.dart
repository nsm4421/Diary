part of '../diary_usecases.dart';

class _CreateDiaryEntryUseCase {
  _CreateDiaryEntryUseCase(this._repository);

  final DiaryRepository _repository;

  Future<Either<Failure, DiaryEntity>> call({
    String? clientId,
    String? title,
    required String content,
    List<File> files = const [],
  }) async {
    if (title != null && title.trim().length > kDiaryEntryMaxTitleLength) {
      return Failure.validation(
        '제목은 최대 $kDiaryEntryMaxTitleLength자까지 입력할 수 있습니다.',
      ).toLeft();
    } else if (content.trim().isEmpty) {
      return Failure.validation('일기 내용을 입력해주세요.').toLeft();
    } else if (content.trimRight().length > kDiaryEntryMaxContentLength) {
      return Failure.validation(
        '일기 내용은 최대 $kDiaryEntryMaxContentLength자까지 작성할 수 있습니다.',
      ).toLeft();
    }

    final id = (clientId == null || clientId.trim().isEmpty)
        ? Uuid().v4()
        : clientId.trim();
    List<CreateDiaryMediaRequest> medias = [];

    if (files.isNotEmpty) {
      debugPrint('[_CreateDiaryEntryUseCase] uploading files on local storage started');
      final uploadResult =
          await _repository.uploadMediaFiles(diaryId: id, files: files);
      final failure = uploadResult.fold<Failure?>(
        (l) => l,
        (uploaded) {
          medias = uploaded;
          return null;
        },
      );
      if (failure != null) {
        debugPrint('[_CreateDiaryEntryUseCase] uploading files on local storage fails');
        return failure.withFriendlyMessage().toLeft();
      }
    }

    return await _repository
        .create(
          clientId: id,
          title: (title == null || title.isEmpty) ? null : title.trim(),
          content: content.trimRight(), // 본문을 DB에 입력할 때는 right trim적용
          medias: medias,
        )
        .then(
          (res) => res.fold((l) => l.withFriendlyMessage().toLeft(), Right.new),
        );
  }
}
