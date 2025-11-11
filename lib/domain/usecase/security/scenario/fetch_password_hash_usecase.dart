part of '../security_usecases.dart';

class _FetchPasswordHashUseCase {
  _FetchPasswordHashUseCase(this._repository, {this.logger});

  final PasswordRepository _repository;
  final Logger? logger;

  Future<Either<Failure, String?>> call() async {
    try {
      final hash = await _repository.fetchPasswordHash();
      return Right(hash);
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
