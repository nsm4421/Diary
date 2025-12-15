part of 'sign_up_cubit.dart';

@CopyWith(copyWithNull: true)
class SignUpState extends SignInState {
  final String displayName;
  final String passwordConfirm;
  final bool isPasswordConfirmObscure;

  SignUpState({
    super.status = Status.initial,
    super.email = '',
    super.password = '',
    this.displayName = '',
    this.passwordConfirm = '',
    super.isPasswordObscure,
    this.isPasswordConfirmObscure = true,
    super.errorMessage,
  });
}
