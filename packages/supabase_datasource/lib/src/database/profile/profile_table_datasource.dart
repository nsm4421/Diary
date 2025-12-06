import 'package:shared/shared.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/tables.dart';
import '../../utils/datasource_exception_handler.dart';

part 'profile_table_datasource_impl.dart';

abstract interface class ProfileTableDataSource {

  Future<Map<String, dynamic>?> fetchProfile(String id);

  Future<Map<String, dynamic>> updateProfile({
    required String id,
    String? displayName,
    String? avatarUrl,
    String? bio,
  });

  Future<void> deleteProfile(String id);
}
