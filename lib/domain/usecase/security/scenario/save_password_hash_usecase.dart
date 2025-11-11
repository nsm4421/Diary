part of '../security_usecases.dart';

class _SavePasswordHashUseCase {
  _SavePasswordHashUseCase(this._repository, {this.logger});

  final PasswordRepository _repository;
  final Logger? logger;

  Future<Either<Failure, Unit>> call({required String hash}) async {
    final trimmed = hash.trim();
    if (trimmed.isEmpty) {
      return Failure.validation('비밀번호 해시가 비어있습니다.').toLeft();
    }

    try {
      await _repository.savePasswordHash(trimmed);
      return const Right(unit);
    } catch (error, stackTrace) {
      logger?.e(error, stackTrace: stackTrace);
      return Failure.unknown(
        message: error.toString(),
        stackTrace: stackTrace,
        details: error,
      ).toLeft();
    }
  }
}
