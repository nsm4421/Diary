part of '../diary_usecases.dart';

class _WatchDiaryEntriesUseCase {
  _WatchDiaryEntriesUseCase(this._repository);

  final DiaryRepository _repository;

  Stream<Either<Failure, List<DiaryEntity>>> call() {
    return _repository.watchAll().map(
      (e) => e.fold((l) => l.withFriendlyMessage().toLeft(), Right.new),
    );
  }
}
