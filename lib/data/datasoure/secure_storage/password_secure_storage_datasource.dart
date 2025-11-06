import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'password_secure_storage_datasource_impl.dart';

abstract interface class PasswordSecureStorageDataSource {
  Future<void> savePasswordHash(String hash);

  Future<String?> fetchPasswordHash();

  Future<void> clearPassword();
}
