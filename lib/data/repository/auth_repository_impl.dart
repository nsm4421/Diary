import 'package:diary/core/response/api_response.dart';
import 'package:diary/data/mapper/auth_user_entity_mapper.dart';
import 'package:diary/data/repository/repository_response_handler.dart';
import 'package:diary/domain/entity/auth/auth_user_entity.dart';
import 'package:diary/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';
import 'package:supabase_datasource/export.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl
    with RepositoryResponseHandlerMixIn
    implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final SupabaseAuthDataSource _dataSource;

  @override
  Stream<AuthUserEntity?> get authStream =>
      _dataSource.authStream.map((user) => user.toEntity());

  @override
  AuthUserEntity? get currentUser => _dataSource.currentUser.toEntity();

  @override
  Future<ApiResponse<AuthUserEntity?>> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _dataSource
          .signInWithPassword(email: email, password: password)
          .then((user) => user.toEntity())
          .then(apiSuccess<AuthUserEntity?>);
    } on ApiException catch (e, st) {
      return fromApiException(error: e, stackTrace: st);
    }
  }

  @override
  Future<ApiResponse<AuthUserEntity?>> signUpWithPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      return await _dataSource
          .signUpWithPassword(
            email: email,
            password: password,
            displayName: displayName,
          )
          .then((user) => user.toEntity())
          .then(apiSuccess<AuthUserEntity?>);
    } on ApiException catch (e, st) {
      return fromApiException(error: e, stackTrace: st);
    }
  }

  @override
  Future<ApiResponse<void>> signOut() async {
    try {
      return await _dataSource.signOut().then(apiSuccess<void>);
    } on ApiException catch (e, st) {
      return fromApiException(error: e, stackTrace: st);
    }
  }

  @override
  Future<ApiResponse<AuthUserEntity?>> setUserAttribute({
    required String displayName,
  }) async {
    try {
      return await _dataSource
          .setUserAttribute(displayName: displayName)
          .then((res) => res.toEntity())
          .then(apiSuccess<AuthUserEntity?>);
    } on ApiException catch (e, st) {
      return fromApiException(error: e, stackTrace: st);
    }
  }
}
