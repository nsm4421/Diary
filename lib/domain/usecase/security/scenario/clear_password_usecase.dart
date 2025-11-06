part of '../security_usecases.dart';

class _ClearPasswordUseCase {
  _ClearPasswordUseCase(this._repository);

  final PasswordRepository _repository;

  Future<Either<Failure, Unit>> call() async {
    try {
      await _repository.clearPassword();
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
