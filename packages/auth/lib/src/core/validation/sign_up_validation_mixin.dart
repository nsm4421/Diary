import 'package:auth/src/core/value_object/auth_failure.dart';
import 'package:shared/shared.dart';

mixin class SignUpValidationMixIn {
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const int minUsernameLength = 2;
  static const int maxUsernameLength = 20;

  Failure? validateEmail(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return AuthFailure(message: '이메일을 입력해주세요');
    }

    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    final isEmailFormat = emailRegex.hasMatch(trimmed);
    if (!isEmailFormat) {
      return AuthFailure(message: '이메일 형식이 아닙니다');
    }
    return null;
  }

  AuthFailure? validatePassword(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return AuthFailure(message: '비밀번호를 입력해주세요');
    }
    if (trimmed.length < minPasswordLength ||
        trimmed.length > maxPasswordLength) {
      return AuthFailure(
        message: '비밀번호는 $minPasswordLength~$maxPasswordLength자 입니다',
      );
    }
    return null;
  }

  AuthFailure? validateUsername(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return AuthFailure(message: '유저명을 입력해주세요');
    }
    if (trimmed.length < minUsernameLength ||
        trimmed.length > maxUsernameLength) {
      return AuthFailure(
        message: '유저명은 $minUsernameLength~$maxUsernameLength자 입니다',
      );
    }
    return null;
  }
}
