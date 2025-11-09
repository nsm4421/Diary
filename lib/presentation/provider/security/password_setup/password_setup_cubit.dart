import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:diary/core/extension/string_extension.dart';
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
    emit(state.copyWith(status: _PasswordSetupStatus.idle, errorMessage: ''));

    await _securityUseCases.fetchPasswordHash().then(
      (res) => res.fold(
        (failure) => emit(state.copyWith(errorMessage: failure.message)),
        (hash) {
          emit(
            state.copyWith(
              status: _PasswordSetupStatus.editing,
              hasExistingPassword: hash != null && hash.isNotEmpty,
              errorMessage: '',
            ),
          );
        },
      ),
    );
  }

  Future<void> setPassword(String password) async {
    emit(
      state.copyWith(status: _PasswordSetupStatus.loading, errorMessage: ''),
    );

    await _securityUseCases.savePasswordHash
        .call(hash: password.trim().hash)
        .then(
          (res) => res
            ..fold(
              (failure) => emit(
                state.copyWith(
                  status: _PasswordSetupStatus.failure,
                  errorMessage: failure.message,
                ),
              ),
              (_) {
                emit(
                  state.copyWith(
                    status: _PasswordSetupStatus.success,
                    hasExistingPassword: true,
                    errorMessage: '',
                  ),
                );
              },
            ),
        );
  }

  Future<void> clearPassword(String password) async {
    emit(
      state.copyWith(status: _PasswordSetupStatus.loading, errorMessage: ''),
    );

    await _securityUseCases.clearPassword.call().then(
      (res) => res.fold(
        (failure) => emit(
          state.copyWith(
            status: _PasswordSetupStatus.failure,
            errorMessage: failure.message,
          ),
        ),
        (_) {
          emit(
            state.copyWith(
              status: _PasswordSetupStatus.success,
              hasExistingPassword: false,
              errorMessage: '',
            ),
          );
        },
      ),
    );
  }

  void resetStatus() {
    emit(
      state.copyWith(status: _PasswordSetupStatus.editing, errorMessage: ''),
    );
  }
}
