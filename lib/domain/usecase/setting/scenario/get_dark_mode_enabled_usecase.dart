part of '../setting_usecases.dart';

class _GetDarkModeEnabledUseCase with FailureHandlerMixin {
  _GetDarkModeEnabledUseCase(this._repository, {this.logger});

  final SettingsRepository _repository;
  final Logger? logger;
  static const _scope = '[Setting][GetDarkMode]';

  Future<Either<Failure, bool>> call() async {
    logger?.useCaseTrace(_scope, '다크모드 상태 조회 시작');
    final result = await _repository.isDarkModeEnabled().then(mapApiResult);
    result.fold(
      (failure) => logger?.useCaseFail(_scope, failure, hint: '조회'),
      (isEnabled) =>
          logger?.useCaseSuccess(_scope, '조회 성공 - enabled=$isEnabled'),
    );
    return result;
  }
}
