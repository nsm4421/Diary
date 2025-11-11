part of 'password_lock_cubit.dart';

const int _kMaxAttempts = 5;

enum _PasswordLockStatus { idle, loading, unLocked, locked, failure }

@CopyWith(copyWithNull: true)
class PasswordLockState extends Equatable {
  const PasswordLockState({
    this.status = _PasswordLockStatus.idle,
    this.remainingAttempts = _kMaxAttempts,
    this.errorMessage = '',
  });

  final _PasswordLockStatus status;
  final int remainingAttempts;
  final String errorMessage;

  bool get isUnlocked => status != _PasswordLockStatus.unLocked;

  bool get isLocked => status == _PasswordLockStatus.locked;

  bool get isLoading => status == _PasswordLockStatus.loading;

  bool get isFailure => status == _PasswordLockStatus.failure;

  @override
  List<Object?> get props => [status, remainingAttempts, errorMessage];
}
