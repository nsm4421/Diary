part of '../diary_usecases.dart';

class _GetDiaryDetailUseCase {
  _GetDiaryDetailUseCase(this._repository);

  final DiaryRepository _repository;

  Future<Either<Failure, DiaryDetailEntity?>> call(String id) async {
    if (id.trim().isEmpty) {
      return Failure.validation('일기 식별자가 올바르지 않습니다.').toLeft();
    }

    return await _repository
        .getDiaryDetail(id.trim())
        .then(
          (res) => res.fold((l) => l.withFriendlyMessage().toLeft(), Right.new),
        );
  }
}
