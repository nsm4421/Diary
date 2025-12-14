import 'package:diary/core/response/api_response.dart';
import 'package:diary/domain/entity/auth/auth_user_entity.dart';

abstract interface class AuthRepository {
  Stream<AuthUserEntity?> get authStream;

  AuthUserEntity? get currentUser;

  Future<ApiResponse<AuthUserEntity?>> signUpWithPassword({
    required String email,
    required String password,
    required String displayName,
  });

  Future<ApiResponse<AuthUserEntity?>> signInWithPassword({
    required String email,
    required String password,
  });

  Future<ApiResponse<void>> signOut();

  Future<ApiResponse<AuthUserEntity?>> setUserAttribute({
    required String displayName,
  });
}
