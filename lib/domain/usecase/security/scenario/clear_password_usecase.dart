part of '../security_usecases.dart';

class _ClearPasswordUseCase with FailureHandlerMixin {
  _ClearPasswordUseCase(this._repository, {this.logger});

  final PasswordRepository _repository;
  final Logger? logger;
  static const _scope = '[Security][ClearPassword]';

  Future<Either<Failure, Unit>> call() async {
    logger?.useCaseTrace(_scope, '패스워드 초기화 시작');
    final result = await _repository.clearPassword().then(mapApiResult);
    result.fold(
      (failure) => logger?.useCaseFail(_scope, failure, hint: '초기화'),
      (unit) => logger?.useCaseSuccess(_scope, '패스워드 초기화 성공'),
    );
    return result;
  }
}
