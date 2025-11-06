part of '../setting_usecases.dart';

class _SetDarkModeEnabledUseCase {
  _SetDarkModeEnabledUseCase(this._repository);

  final SettingsRepository _repository;

  Future<Either<Failure, Unit>> call({required bool isEnabled}) async {
    try {
      await _repository.setDarkModeEnabled(isEnabled);
      return const Right(unit);
    } catch (error, stackTrace) {
      return Failure.unknown(
        message: error.toString(),
        stackTrace: stackTrace,
        details: error,
      ).toLeft();
    }
  }
}
