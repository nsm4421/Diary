import 'package:diary/domain/entity/auth/auth_user_entity.dart';
import 'package:supabase_datasource/export.dart';

extension AuthUserModelX on AuthUserModel? {
  AuthUserEntity? toEntity() {
    return this == null
        ? null
        : AuthUserEntity(
            id: this!.id,
            email: this!.email,
            displayName: this!.displayName,
          );
  }
}
