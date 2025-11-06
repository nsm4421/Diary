part of 'password_secure_storage_datasource.dart';

const String _kPasswordKey = 'secure.password.hash';

class PasswordSecureStorageDataSourceImpl
    implements PasswordSecureStorageDataSource {
  PasswordSecureStorageDataSourceImpl(this._storage);

  final FlutterSecureStorage _storage;

  IOSOptions get _iosOptions => const IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      );

  AndroidOptions get _androidOptions => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  @override
  Future<void> savePasswordHash(String hash) async {
    await _storage.write(
      key: _kPasswordKey,
      value: hash,
      iOptions: _iosOptions,
      aOptions: _androidOptions,
    );
  }

  @override
  Future<String?> fetchPasswordHash() async {
    return _storage.read(
      key: _kPasswordKey,
      iOptions: _iosOptions,
      aOptions: _androidOptions,
    );
  }

  @override
  Future<void> clearPassword() async {
    await _storage.delete(
      key: _kPasswordKey,
      iOptions: _iosOptions,
      aOptions: _androidOptions,
    );
  }
}
