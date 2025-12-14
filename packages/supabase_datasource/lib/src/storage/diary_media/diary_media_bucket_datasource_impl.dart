part of 'diary_media_bucket_datasource.dart';

class SupabaseDiaryMediaBucketDataSourceImpl
    with DiaryMediaUtilMixIn, SupabaseDataSourceExceptionHandlerMixIn
    implements SupabaseDiaryMediaBucketDataSource {
  final SupabaseClient _client;
  final SupabaseStorageDataSource _storage;

  SupabaseDiaryMediaBucketDataSourceImpl(this._client, this._storage);

  String get _currentUid {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      throw AuthException('user not found');
    }
    return uid;
  }

  String get _bucket => SupabaseBuckets.diaryMedia.name;

  @override
  Future<String> uploadMedia({
    required String diaryId,
    required String storyId,
    required File media,
  }) async {
    try {
      final path = buildDiaryMediaPath(
        userId: _currentUid,
        diaryId: diaryId,
        storyId: storyId,
      );
      return await _storage.uploadFile(
        bucket: _bucket,
        path: path,
        file: media,
      );
    } catch (error, stackTrace) {
      throw toApiException(error, stackTrace);
    }
  }

  @override
  Future<void> deleteMedia(Iterable<String> paths) async {
    try {
      await _storage.removeAll(bucket: _bucket, paths: paths);
    } catch (error, stackTrace) {
      throw toApiException(error, stackTrace);
    }
  }
}
