import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:diary/core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:shared/shared.dart';

part 'state.dart';

part 'cubit.freezed.dart';

@injectable
class SignUpCubit extends Cubit<SignUpState> with SignUpValidationMixIn {
  final AuthService _authService;
  final Logger _logger;

  SignUpCubit(this._authService, this._logger) : super(SignUpState());

  void resetStatus() {
    if (state.status == Status.error) return;
    emit(state.copyWith(status: Status.initial, failure: null));
  }

  void updateEmail(String text) {
    if (state.status == Status.loading) return;
    emit(state.copyWith(email: text));
  }

  void updatePassword(String text) {
    if (state.status == Status.loading) return;
    emit(state.copyWith(password: text));
  }

  void updateUsername(String text) {
    if (state.status == Status.loading) return;
    emit(state.copyWith(username: text));
  }

  Future<void> submit() async {
    if (state.status == Status.loading) return;
    emit(
      state.copyWith(
        email: state.email.trim(),
        password: state.password.trim(),
        username: state.username.trim(),
      ),
    );

    /// validation
    final emailError = validateEmail(state.email);
    if (emailError != null) {
      emit(state.copyWith(status: Status.error, failure: emailError));
      return;
    }
    final passwordError = validateEmail(state.password);
    if (passwordError != null) {
      emit(state.copyWith(status: Status.error, failure: passwordError));
      return;
    }
    final usernameError = validateEmail(state.username);
    if (usernameError != null) {
      emit(state.copyWith(status: Status.error, failure: usernameError));
      return;
    }

    /// call service
    emit(state.copyWith(status: Status.loading));
    (await _authService
            .signUpWithEmail(
              email: state.email,
              password: state.password,
              username: state.username,
              // TODO : AvatarUrl 등록
            )
            .run())
        .match(
          (failure) {
            _logger.failure(failure);
            emit(state.copyWith(status: Status.error, failure: failure));
          },
          (authUser) {
            _logger.t('sign up success');
            emit(state.copyWith(status: Status.success, failure: null));
          },
        );
  }
}
