part of 'cubit.dart';

@freezed
class SignUpState with _$SignUpState {
  @override
  final Status status;
  @override
  final String email;
  @override
  final String password;
  @override
  final String username;
  @override
  final Failure? failure;

  SignUpState({
    this.status = Status.initial,
    this.email = '',
    this.password = '',
    this.username = '',
    this.failure,
  });
}
