import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:diary/core/constant/error_code.dart';
import 'package:diary/core/value_objects/error/failure.dart';
import 'package:diary/core/extension/string_extension.dart';
import 'package:diary/core/constant/status.dart';
import 'package:diary/domain/usecase/security/security_usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'password_setup_state.dart';

part 'password_setup_cubit.g.dart';

@injectable
class PasswordSetupCubit extends Cubit<PasswordSetupState> {
  PasswordSetupCubit(this._securityUseCases)
    : super(const PasswordSetupState());

  final SecurityUseCases _securityUseCases;

  Future<void> init() async {
    emit(state.copyWith(status: PasswordSetupStatus.idle, errorMessage: ''));

    await _securityUseCases.fetchPasswordHash().then(
      (res) => res.fold(
        (failure) => emit(state.copyWith(errorMessage: _failureMessage(failure))),
        (hash) {
          emit(
            state.copyWith(
              status: PasswordSetupStatus.editing,
              hasExistingPassword: hash != null && hash.isNotEmpty,
              errorMessage: '',
            ),
          );
        },
      ),
    );
  }

  Future<void> setPassword(String password) async {
    emit(state.copyWith(status: PasswordSetupStatus.loading, errorMessage: ''));

    await _securityUseCases.savePasswordHash
        .call(hash: password.trim().hash)
        .then(
          (res) => res
            ..fold(
              (failure) => emit(
                state.copyWith(
                  status: PasswordSetupStatus.failure,
                  errorMessage: _failureMessage(failure),
                ),
              ),
              (_) {
                emit(
                  state.copyWith(
                    status: PasswordSetupStatus.success,
                    hasExistingPassword: true,
                    errorMessage: '',
                  ),
                );
              },
            ),
        );
  }

  Future<void> clearPassword(String password) async {
    emit(state.copyWith(status: PasswordSetupStatus.loading, errorMessage: ''));

    await _securityUseCases.clearPassword.call().then(
      (res) => res.fold(
        (failure) => emit(
          state.copyWith(
            status: PasswordSetupStatus.failure,
            errorMessage: _failureMessage(failure),
          ),
        ),
        (_) {
          emit(
            state.copyWith(
              status: PasswordSetupStatus.success,
              hasExistingPassword: false,
              errorMessage: '',
            ),
          );
        },
      ),
    );
  }

  void resetStatus() {
    emit(state.copyWith(status: PasswordSetupStatus.editing, errorMessage: ''));
  }

  String _failureMessage(Failure failure) {
    return switch (failure.code) {
      ErrorCode.validation => failure.description,
      ErrorCode.storage ||
      ErrorCode.cache ||
      ErrorCode.database =>
        '비밀번호 설정을 처리하지 못했습니다. 잠시 후 다시 시도해주세요.',
      _ => failure.description,
    };
  }
}
