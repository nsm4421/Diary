abstract interface class PasswordRepository {
  /// 저장할 비밀번호는 해시 등의 안전한 형태로 전달해주세요.
  Future<void> savePasswordHash(String hash);

  Future<String?> fetchPasswordHash();

  Future<void> clearPassword();
}
