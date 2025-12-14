import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:diary/core/constant/status.dart';
import 'package:diary/domain/usecase/auth/auth_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

part 'sign_in_state.dart';

part 'sign_in_cubit.g.dart';

@injectable
class SignInCubit extends Cubit<SignInState> {
  final AuthUseCases _useCases;
  final Logger _logger;

  SignInCubit(this._useCases, this._logger) : super(SignInState());

  void initStatus() {
    emit(state.copyWith(status: Status.initial));
  }

  void updateState({String? email, String? password, bool? isPasswordObscure}) {
    if (!state.isEditable) return;
    emit(
      state.copyWith(
        email: email ?? state.email,
        password: password ?? state.password,
        isPasswordObscure: isPasswordObscure ?? state.isPasswordObscure,
      ),
    );
  }

  Future<void> submit() async {
    emit(state.copyWith(status: Status.loading));

    try {
      await _useCases.signIn
          .call(email: state.email, password: state.password)
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
      final errorMessage = 'submitting fails on sign in cubit';
      _logger.e(errorMessage, error: e, stackTrace: st);
      emit(state.copyWith(status: Status.error, errorMessage: errorMessage));
    }
  }
}
