import 'package:diary/data/datasoure/secure_storage/password_secure_storage_datasource.dart';
import 'package:diary/domain/repository/password_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PasswordRepository)
class PasswordRepositoryImpl implements PasswordRepository {
  PasswordRepositoryImpl(this._secureStorage);

  final PasswordSecureStorageDataSource _secureStorage;

  @override
  Future<void> savePasswordHash(String hash) async {
    await _secureStorage.savePasswordHash(hash);
  }

  @override
  Future<String?> fetchPasswordHash() async {
    return _secureStorage.fetchPasswordHash();
  }

  @override
  Future<void> clearPassword() async {
    await _secureStorage.clearPassword();
  }
}
