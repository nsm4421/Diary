part of 'password_setup_cubit.dart';

@CopyWith(copyWithNull: true)
class PasswordSetupState extends Equatable {
  const PasswordSetupState({
    this.status = PasswordSetupStatus.idle,
    this.hasExistingPassword = false,
    this.errorMessage = '',
  });

  final PasswordSetupStatus status;
  final bool hasExistingPassword;
  final String errorMessage;

  bool get isStatusIdle => status == PasswordSetupStatus.idle;

  bool get isStatusEditing => status == PasswordSetupStatus.editing;

  bool get isStatusLoading => status == PasswordSetupStatus.loading;

  bool get isStatusSuccess => status == PasswordSetupStatus.success;

  bool get isStatusFailure => status == PasswordSetupStatus.failure;

  @override
  List<Object?> get props => [status, hasExistingPassword, errorMessage];
}
