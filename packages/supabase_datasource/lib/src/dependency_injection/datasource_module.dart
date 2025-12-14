import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_datasource.dart';
import '../database/diary/diary_datasource.dart';
import '../storage/diary_media/diary_media_bucket_datasource.dart';
import '../storage/storage_datasource.dart';

@module
abstract class SupabaseDataSourceModule {
  @preResolve
  SupabaseClient get _client => Supabase.instance.client;

  @lazySingleton
  SupabaseAuthDataSource get auth => SupabaseAuthDataSourceImpl(_client);

  @lazySingleton
  SupabaseDiaryDataSource get diary => SupabaseDiaryDataSourceImpl(_client);

  @lazySingleton
  SupabaseStorageDataSource get _storage =>
      SupabaseStorageDataSourceImpl(_client);

  @lazySingleton
  SupabaseDiaryMediaBucketDataSource get diaryMediaBucket =>
      SupabaseDiaryMediaBucketDataSourceImpl(_client, _storage);
}
