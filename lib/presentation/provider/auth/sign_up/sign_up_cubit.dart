import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:diary/core/constant/status.dart';
import 'package:diary/domain/usecase/auth/auth_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../sign_in/sign_in_cubit.dart';

part 'sign_up_state.dart';

part 'sign_up_cubit.g.dart';

@injectable
class SignUpCubit extends Cubit<SignUpState> {
  final AuthUseCases _useCases;
  final Logger _logger;

  SignUpCubit(this._useCases, this._logger) : super(SignUpState());

  void initStatus() {
    emit(state.copyWith(status: Status.initial));
  }

  void updateState({
    String? email,
    String? password,
    String? passwordConfirm,
    String? displayName,
    bool? isPasswordObscure,
    bool? isPasswordConfirmObscure,
  }) {
    if (!state.isEditable) return;
    emit(
      state.copyWith(
        email: email ?? state.email,
        password: password ?? state.password,
        passwordConfirm: passwordConfirm ?? state.passwordConfirm,
        displayName: displayName ?? state.displayName,
        isPasswordObscure: isPasswordObscure ?? state.isPasswordObscure,
        isPasswordConfirmObscure:
            isPasswordConfirmObscure ?? state.isPasswordConfirmObscure,
      ),
    );
  }

  Future<void> submit() async {
    emit(state.copyWith(status: Status.loading));

    try {
      await _useCases.signUp
          .call(
            email: state.email,
            password: state.password,
            displayName: state.displayName,
          )
          .then(
            (res) => res.fold(
              (l) {
                emit(
                  state.copyWith(status: Status.error, errorMessage: l.message),
                );
              },
              (r) {
                emit(
                  state
                      .copyWith(status: Status.success)
                      .copyWithNull(errorMessage: true),
                );
              },
            ),
          );
    } catch (e, st) {
      final errorMessage = 'submitting fails on sign up cubit';
      _logger.e(errorMessage, error: e, stackTrace: st);
      emit(state.copyWith(status: Status.error, errorMessage: errorMessage));
    }
  }
}
