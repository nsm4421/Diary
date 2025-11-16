part of '../security_usecases.dart';

class _SavePasswordHashUseCase with FailureHandlerMixin {
  _SavePasswordHashUseCase(this._repository, {this.logger});

  final PasswordRepository _repository;
  final Logger? logger;
  static const _scope = '[Security][SavePassword]';

  Future<Either<Failure, Unit>> call({required String hash}) async {
    final trimmed = hash.trim();
    logger?.useCaseTrace(_scope, '패스워드 저장 요청 수신');
    if (trimmed.isEmpty) {
      final failure = Failure.validation('Password hash must not be empty.');
      logger?.useCaseFail(_scope, failure, hint: '입력값 검증');
      return failure.toLeft();
    }

    logger?.useCaseTrace(_scope, '저장소에 패스워드 저장 시도');
    final result = await _repository
        .savePasswordHash(trimmed)
        .then(mapApiResult);
    result.fold(
      (failure) => logger?.useCaseFail(_scope, failure, hint: '저장'),
      (_) => logger?.useCaseSuccess(_scope, '패스워드 저장 성공'),
    );
    return result;
  }
}
