import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_datasource.dart';
import '../database/diary/diary_datasource.dart';
import '../storage/story_bucket_datasource.dart';

@module
abstract class SupabaseDataSourceModule {
  @preResolve
  SupabaseClient get _client => Supabase.instance.client;

  @lazySingleton
  SupabaseAuthDataSource get auth => SupabaseAuthDataSourceImpl(_client);

  @lazySingleton
  SupabaseDiaryDataSource get diary => SupabaseDiaryDataSourceImpl(_client);

  @lazySingleton
  SupabaseStoryBucketDataSource get storyBucket => SupabaseStoryBucketDataSource(_client);
}
