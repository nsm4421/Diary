part of '../setting_usecases.dart';

class _GetDarkModeEnabledUseCase {
  _GetDarkModeEnabledUseCase(this._repository);

  final SettingsRepository _repository;

  Future<Either<Failure, bool>> call() async {
    try {
      final isEnabled = await _repository.isDarkModeEnabled();
      return Right(isEnabled);
    } catch (error, stackTrace) {
      return Failure.unknown(
        message: error.toString(),
        stackTrace: stackTrace,
        details: error,
      ).toLeft();
    }
  }
}
