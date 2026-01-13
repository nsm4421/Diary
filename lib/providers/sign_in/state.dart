part of 'cubit.dart';

@freezed
class SignInState with _$SignInState {
  @override
  final Status status;
  @override
  final String email;
  @override
  final String password;
  @override
  final Failure? failure;

  SignInState({
    this.status = Status.initial,
    this.email = '',
    this.password = '',
    this.failure,
  });
}

extension SignInStateExtension on SignInState {
  bool get canRequest => status == Status.initial;
}
