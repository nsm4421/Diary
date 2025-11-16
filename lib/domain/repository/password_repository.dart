import 'package:dartz/dartz.dart';
import 'package:diary/core/error/api/api_error.dart';

abstract interface class PasswordRepository {
  Future<Either<ApiError, Unit>> savePasswordHash(String hash);

  Future<Either<ApiError, String?>> fetchPasswordHash();

  Future<Either<ApiError, Unit>> clearPassword();
}
