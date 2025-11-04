part of '../diary_usecases.dart';

class _UpdateDiaryEntryUseCase {
  _UpdateDiaryEntryUseCase(this._repository);

  final DiaryRepository _repository;

  Future<Either<Failure, DiaryEntity>> call({
    required String id,
    String? title,
    required String content,
  }) async {
    if (id.trim().isEmpty) {
      return Failure.validation('일기 식별자가 올바르지 않습니다.').toLeft();
    } else if (content.trim().isEmpty) {
      return Failure.validation('일기 내용을 입력해주세요.').toLeft();
    } else if (content.trimRight().length > kDiaryEntryMaxContentLength) {
      return Failure.validation(
        '일기 내용은 최대 $kDiaryEntryMaxContentLength자까지 작성할 수 있습니다.',
      ).toLeft();
    }

    return await _repository
        .update(
          diaryId: id.trim(),
          title: (title == null || title.isEmpty) ? null : title,
          content: content.trimRight(), // 본문을 DB에 입력할 때는 right trim적용
        )
        .then(
          (res) => res.fold((l) => l.withFriendlyMessage().toLeft(), Right.new),
        );
  }
}
