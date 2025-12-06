import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_datasource.dart';
import '../database/profile/profile_table_datasource.dart';

@module
abstract class SupabaseDataSourceModule {
  @preResolve
  SupabaseClient get _client => Supabase.instance.client;

  @lazySingleton
  SupabaseAuthDataSource get auth =>
      SupabaseAuthDataSourceImpl(_client);

  @lazySingleton
  ProfileTableDataSource get profileTable =>
      ProfileTableDataSourceImpl(_client);
}
