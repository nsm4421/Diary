import 'dart:io';

import 'package:supabase_datasource/src/utils/diary_media_util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/buckets.dart';
import '../../utils/datasource_exception_handler.dart';
import '../storage_datasource.dart';

part 'diary_media_bucket_datasource_impl.dart';

abstract interface class SupabaseDiaryMediaBucketDataSource {
  Future<String> uploadMedia({
    required String diaryId,
    required String storyId,
    required File media,
  });

  Future<void> deleteMedia(Iterable<String> paths);
}
