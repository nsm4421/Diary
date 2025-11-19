part of '../diary_usecases.dart';

class _FindAllByMonthUseCase with FailureHandlerMixin {
  _FindAllByMonthUseCase(this._repository, {this.logger});

  final DiaryRepository _repository;
  final Logger? logger;
  static const _scope = '[Diary][FindAllByMonth]';

  Future<Either<Failure, List<DiaryEntity>>> call(DateTime date) async {
    logger?.useCaseTrace(_scope, 'Date:${date.yyyymmdd}');

    final res = await _repository
        .findAllByDateRange(
          start: DateTime(date.year, date.month, 1),
          end: DateTime(date.year, date.month + 1, 0),
        )
        .then(mapApiResult);

    res.fold(
      (failure) {
        logger?.useCaseFail(_scope, failure, hint: '조회');
      },
      (entities) {
        entities.isEmpty
            ? logger?.useCaseTrace(_scope, '조회 성공 - 빈 결과')
            : logger?.useCaseSuccess(_scope, '조회 성공 - ${entities.length}건 반환');
      },
    );

    return res;
  }
}
