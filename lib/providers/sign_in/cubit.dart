import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:shared/shared.dart';
import 'package:diary/core/core.dart';

part 'state.dart';

part 'cubit.freezed.dart';

@injectable
class SignInCubit extends Cubit<SignInState> {
  final AuthService _authService;
  final Logger _logger;

  SignInCubit(this._authService, this._logger) : super(SignInState());

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

  Future<void> submit() async {
    if (state.status == Status.loading) return;

    /// call service
    emit(
      state.copyWith(
        status: Status.loading,
        email: state.email.trim(),
        password: state.password.trim(),
      ),
    );
    (await _authService
            .signInWithEmail(email: state.email, password: state.password)
            .run())
        .match(
          (failure) {
            _logger.failure(failure);
            emit(state.copyWith(status: Status.error, failure: failure));
          },
          (authUser) {
            _logger.t('sign in success');
            emit(state.copyWith(status: Status.success, failure: null));
          },
        );
  }
}
