import 'package:dartz/dartz.dart';
import 'package:diary/core/error/api/api_error.dart';
import 'package:diary/core/error/api/api_error_handler.dart';
import 'package:diary/data/datasoure/secure_storage/password_secure_storage_datasource.dart';
import 'package:diary/domain/repository/password_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PasswordRepository)
class PasswordRepositoryImpl
    with ApiErrorHandlerMiIn
    implements PasswordRepository {
  PasswordRepositoryImpl(this._secureStorage);

  final PasswordSecureStorageDataSource _secureStorage;

  @override
  Future<Either<ApiError, Unit>> savePasswordHash(String hash) {
    return guard(
      () => _secureStorage.savePasswordHash(hash).then((_) => unit),
      fallbackCode: ApiErrorCode.storage,
    );
  }

  @override
  Future<Either<ApiError, String?>> fetchPasswordHash() {
    return guard(
      () => _secureStorage.fetchPasswordHash(),
      fallbackCode: ApiErrorCode.storage,
    );
  }

  @override
  Future<Either<ApiError, Unit>> clearPassword() {
    return guard(
      () => _secureStorage.clearPassword().then((_) => unit),
      fallbackCode: ApiErrorCode.storage,
    );
  }
}
