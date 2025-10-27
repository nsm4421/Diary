part of '../diary_usecases.dart';

class _CreateDiaryEntryUseCase {
  _CreateDiaryEntryUseCase(this._repository);

  final DiaryRepository _repository;

  Future<Either<Failure, DiaryEntry>> call({
    String? clientId,
    String? title,
    required String content,
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

    return await _repository
        .create(
          clientId: clientId?.trim(),
          title: (title == null || title.isEmpty) ? null : title.trim(),
          content: content.trimRight(), // 본문을 DB에 입력할 때는 right trim적용
        )
        .then(
          (res) => res.fold((l) => l.withFriendlyMessage().toLeft(), Right.new),
        );
  }
}
