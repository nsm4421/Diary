import 'package:diary/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../service/auth_service.dart';
import '../../model/auth_user_model.dart';

part 'sign_in_state.dart';

part 'sign_in_cubit.freezed.dart';

class SignInCubit extends Cubit<SignInState> {
  late final GlobalKey<FormState> _formKey;
  final AuthService _authService;

  SignInCubit(this._authService)
    : super(_EditingState((email: '', password: ''))) {
    _formKey = GlobalKey<FormState>(debugLabel: 'SIGN_IN');
  }

  GlobalKey<FormState> get formKey => _formKey;

  void resetError() {
    if (!state.isError) return;
    final input = (state as _FailureState).input;
    emit(_EditingState(input));
  }

  void updateState({String? email, String? password}) {
    state.whenOrNull(
      editing: (current) {
        emit(
          _EditingState((
            email: email ?? current.email,
            password: password ?? current.password,
          )),
        );
      },
    );
  }

  Future<void> submit() async {
    if (!state.isEditing) return;
    final input = (state as _EditingState).input;

    emit(_LoadingState(input));

    /// validation
    _formKey.currentState?.save();
    final ok = _formKey.currentState?.validate();
    if (ok == null) {
      emit(
        _FailureState(
          input: input,
          failure: Failure(message: 'form key is not attached'),
        ),
      );
      return;
    } else if (!ok) {
      emit(
        _FailureState(
          input: input,
          failure: Failure(message: 'user input is not valid'),
        ),
      );
      return;
    }

    /// call service
    (await _authService
            .signInWithEmail(
              email: input.email.trim(),
              password: input.password.trim(),
            )
            .run())
        .match(
          (failure) {
            emit(_FailureState(input: input, failure: failure));
          },
          (authUser) {
            emit(_SuccessState(authUser));
          },
        );
  }
}
