part of '../setting_usecases.dart';

class _SetDarkModeEnabledUseCase with FailureHandlerMixin {
  _SetDarkModeEnabledUseCase(this._repository, {this.logger});

  final SettingsRepository _repository;
  final Logger? logger;
  static const _scope = '[Setting][SetDarkMode]';

  Future<Either<Failure, Unit>> call({required bool isEnabled}) async {
    logger?.useCaseTrace(_scope, '다크모드 토글 요청 (enabled=$isEnabled)');
    final result = await _repository
        .setDarkModeEnabled(isEnabled)
        .then(mapApiResult);
    result.fold(
      (failure) => logger?.useCaseFail(_scope, failure, hint: '저장'),
      (_) => logger?.useCaseSuccess(_scope, '다크모드 토글 완료'),
    );
    return result;
  }
}
