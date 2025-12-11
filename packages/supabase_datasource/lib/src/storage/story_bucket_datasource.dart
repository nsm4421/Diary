import 'package:supabase_datasource/src/storage/storage_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/buckets.dart';

class SupabaseStoryBucketDataSource extends SupabaseStorageDataSourceImpl {
  final SupabaseClient _client;

  SupabaseStoryBucketDataSource(this._client)
    : super(client: _client, bucket: SupabaseBuckets.avatar.name);
}
