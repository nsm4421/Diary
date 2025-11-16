part of '../diary_usecases.dart';

class _WatchDiaryEntriesUseCase with FailureHandlerMixin {
  _WatchDiaryEntriesUseCase(this._repository, {this.logger});

  final DiaryRepository _repository;
  final Logger? logger;
  static const _scope = '[Diary][Watch]';

  Stream<Either<Failure, List<DiaryEntity>>> call() {
    logger?.useCaseTrace(_scope, '스트림 구독 시작');

    return _repository.watchAll().map(
      (event) => mapApiResult(event).fold(
        (failure) {
          logger?.useCaseFail(_scope, failure, hint: '스트림 이벤트');
          return Left(failure);
        },
        (entities) {
          logger?.useCaseTrace(_scope, '스트림 이벤트 수신 - ${entities.length}건');
          return Right(entities);
        },
      ),
    );
  }
}
