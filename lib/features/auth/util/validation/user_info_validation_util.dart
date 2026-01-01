const int kMinUsernameLength = 2;
const int kMaxUsernameLength = 20;
const int kMinPasswordLength = 6;
const int kMaxPasswordLength = 30;

mixin class UserInfoValidatorMixIn {
  String? validateUsername(String? text) {
    if (text == null || text.isEmpty) {
      return 'username is not given';
    } else if (text.trim().length < kMinUsernameLength) {
      return 'username length should be larger or equal than $kMinUsernameLength ';
    } else if (text.trim().length > kMaxUsernameLength) {
      return 'username length should be less than $kMaxUsernameLength';
    }
    return null;
  }

  String? validateEmail(String? text) {
    if (text == null || text.isEmpty) {
      return 'email is not given';
    }
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(text.trim())) {
      return 'email is invaid';
    }
    return null;
  }

  String? validatePassword(String? text) {
    if (text == null || text.isEmpty) {
      return 'password is not given';
    } else if (text.trim().length < kMinPasswordLength) {
      return 'password length should be larger or equal than $kMinPasswordLength ';
    } else if (text.trim().length > kMaxPasswordLength) {
      return 'password length should be less than $kMaxPasswordLength';
    }
    return null;
  }
}
