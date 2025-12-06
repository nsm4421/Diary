import 'package:diary/core/response/api_response.dart';
import 'package:diary/data/mapper/auth_user_entity_mapper.dart';
import 'package:diary/data/repository/repository_response_handler.dart';
import 'package:diary/domain/entity/auth/auth_user_entity.dart';
import 'package:diary/domain/repository/auth/auth_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';
import 'package:supabase_datasource/export.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl
    with RepositoryResponseHandlerMixIn
    implements AuthRepository {
  AuthRepositoryImpl(this._authDataSource);

  final SupabaseAuthDataSource _authDataSource;

  @override
  Stream<AuthUserEntity?> get authStream =>
      _authDataSource.authStream.map((user) => user.toEntity());

  @override
  AuthUserEntity? get currentUser => _authDataSource.currentUser.toEntity();

  @override
  Future<ApiResponse<AuthUserEntity?>> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _authDataSource
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
    String? avatarUrl,
    String? bio,
  }) async {
    try {
      return await _authDataSource
          .signUpWithPassword(
            email: email,
            password: password,
            displayName: displayName,
            avatarUrl: avatarUrl,
            bio: bio,
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
      return await _authDataSource.signOut().then(apiSuccess<void>);
    } on ApiException catch (e, st) {
      return fromApiException(error: e, stackTrace: st);
    }
  }
}
