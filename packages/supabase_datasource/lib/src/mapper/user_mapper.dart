import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/auth/auth_user_model.dart';

extension NullableUserX on User? {
  AuthUserModel? toAuthUser() {
    return this == null ? null : AuthUserModel.fromSupabaseUser(this!);
  }
}
