part of '../security_usecases.dart';

class _FetchPasswordHashUseCase with FailureHandlerMixin {
  _FetchPasswordHashUseCase(this._repository, {this.logger});

  final PasswordRepository _repository;
  final Logger? logger;
  static const _scope = '[Security][FetchPassword]';

  Future<Either<Failure, String?>> call() async {
    logger?.useCaseTrace(_scope, '패스워드 조회 시작');
    final result = await _repository.fetchPasswordHash().then(mapApiResult);
    result.fold(
      (failure) => logger?.useCaseFail(_scope, failure, hint: '조회'),
      (hash) => logger?.useCaseSuccess(
        _scope,
        hash == null ? '저장된 패스워드 없음' : '패스워드 조회 성공',
      ),
    );
    return result;
  }
}
