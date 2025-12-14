part of 'sign_in_cubit.dart';

@CopyWith(copyWithNull: true)
class SignInState {
  final Status status;
  final String email;
  final String password;
  final bool isPasswordObscure;
  final String? errorMessage;

  SignInState({
    this.status = Status.initial,
    this.email = '',
    this.password = '',
    this.isPasswordObscure = true,
    this.errorMessage,
  });

  bool get isLoading => status == Status.loading;

  bool get isEditable => status == Status.initial;

  bool get isSuccess => status == Status.success;

  bool get isError => status == Status.error;
}
