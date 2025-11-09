part of 'password_setup_cubit.dart';

enum _PasswordSetupStatus { idle, editing, loading, success, failure }

@CopyWith(copyWithNull: true)
class PasswordSetupState extends Equatable {
  const PasswordSetupState({
    this.status = _PasswordSetupStatus.idle,
    this.hasExistingPassword = false,
    this.errorMessage = '',
  });

  final _PasswordSetupStatus status;
  final bool hasExistingPassword;
  final String errorMessage;

  bool get isStatusIdle => status == _PasswordSetupStatus.idle;
  bool get isStatusEditing => status == _PasswordSetupStatus.editing;
  bool get isStatusLoading => status == _PasswordSetupStatus.loading;
  bool get isStatusSuccess => status == _PasswordSetupStatus.success;
  bool get isStatusFailure => status == _PasswordSetupStatus.failure;

  @override
  List<Object?> get props => [status, hasExistingPassword, errorMessage];
}
