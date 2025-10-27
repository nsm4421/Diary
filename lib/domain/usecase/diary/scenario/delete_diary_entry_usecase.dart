part of '../diary_usecases.dart';

class _DeleteDiaryEntryUseCase {
  _DeleteDiaryEntryUseCase(this._repository);

  final DiaryRepository _repository;

  Future<Either<Failure, void>> call(String id) async {
    if (id.trim().isEmpty) {
      return Failure.validation('일기 식별자가 올바르지 않습니다.').toLeft();
    }

    return await _repository
        .delete(id.trim())
        .then(
          (res) => res.fold((l) => l.withFriendlyMessage().toLeft(), Right.new),
        );
  }
}
