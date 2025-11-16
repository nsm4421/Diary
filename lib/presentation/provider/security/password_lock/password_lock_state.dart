part of 'password_lock_cubit.dart';

const int _kMaxAttempts = 5;

@CopyWith(copyWithNull: true)
class PasswordLockState extends Equatable {
  const PasswordLockState({
    this.status = PasswordLockStatus.idle,
    this.remainingAttempts = _kMaxAttempts,
    this.errorMessage = '',
  });

  final PasswordLockStatus status;
  final int remainingAttempts;
  final String errorMessage;

  bool get isUnlocked => status != PasswordLockStatus.unLocked;

  bool get isLocked => status == PasswordLockStatus.locked;

  bool get isLoading => status == PasswordLockStatus.loading;

  bool get isFailure => status == PasswordLockStatus.failure;

  @override
  List<Object?> get props => [status, remainingAttempts, errorMessage];
}
