import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:diary/core/extension/string_extension.dart';
import 'package:diary/domain/usecase/security/security_usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'password_lock_state.dart';

part 'password_lock_cubit.g.dart';

@injectable
class PasswordLockCubit extends Cubit<PasswordLockState> {
  PasswordLockCubit(this._securityUseCases) : super(const PasswordLockState());

  final SecurityUseCases _securityUseCases;
  String? _cachedHash;

  Future<void> init() async {
    emit(state.copyWith(status: _PasswordLockStatus.loading));

    await _securityUseCases.fetchPasswordHash().then(
      (res) => res.fold(
        (failure) => emit(
          state.copyWith(
            status: _PasswordLockStatus.idle,
            errorMessage: failure.message,
          ),
        ),
        (hashPassword) {
          _cachedHash = hashPassword;
          emit(
            state.copyWith(
              status: hashPassword == null
                  ? _PasswordLockStatus.unLocked
                  : _PasswordLockStatus.locked,
              remainingAttempts: _kMaxAttempts,
            ),
          );
        },
      ),
    );
  }

  Future<void> submit(String password) async {
    emit(state.copyWith(status: _PasswordLockStatus.loading));

    // 남은 시도 횟수 검사
    if (state.remainingAttempts == 0) {
      emit(
        state.copyWith(
          status: _PasswordLockStatus.failure,
          errorMessage: '허용된 시도 횟수를 초과했습니다',
        ),
      );
      return;
    }

    // 비밀번호 입력값 검사
    if (password.trim().isEmpty) {
      emit(
        state.copyWith(
          status: _PasswordLockStatus.failure,
          errorMessage: '비밀번호를 입력해주세요',
        ),
      );
      return;
    }

    // 비밀번호 일치여부 검사
    final hashedPassword = password.hash;
    if (hashedPassword != _cachedHash) {
      emit(
        state.copyWith(
          status: _PasswordLockStatus.failure,
          errorMessage: '비밀번호가 일치하지 않습니다',
          remainingAttempts: (state.remainingAttempts - 1).clamp(
            0,
            _kMaxAttempts,
          ),
        ),
      );
      return;
    }

    // 성공
    await Future.delayed(Duration(milliseconds: 500));
    emit(
      state.copyWith(status: _PasswordLockStatus.unLocked, errorMessage: ''),
    );
  }

  void resetStatus() {
    emit(state.copyWith(status: _PasswordLockStatus.locked, errorMessage: ''));
  }
}
