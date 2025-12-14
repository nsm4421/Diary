part of 'diary_datasource.dart';

class SupabaseDiaryDataSourceImpl
    with SupabaseDataSourceExceptionHandlerMixIn, DiaryMediaUtilMixIn
    implements SupabaseDiaryDataSource {
  final SupabaseClient _client;

  SupabaseDiaryDataSourceImpl(this._client);

  String get _currentUid {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      throw AuthException('user not found');
    }
    return uid;
  }

  PostgrestQueryBuilder get _diaryTable =>
      _client.rest.from(SupabaseTables.diary.name);

  PostgrestQueryBuilder get _diaryView =>
      _client.rest.from(SupabaseTables.diaryListView.name);

  PostgrestQueryBuilder get _storyTable =>
      _client.rest.from(SupabaseTables.story.name);

  PostgrestQueryBuilder get _mediaTable =>
      _client.rest.from(SupabaseTables.media.name);

  /// Diary
  @override
  Future<DiaryModel> insertDiary({
    required String diaryId,
    String? title,
  }) async {
    try {
      final data = {'id': diaryId, if (title != null) 'title': title};
      return await _diaryTable
          .insert(data)
          .select()
          .single()
          .then(DiaryModel.fromJson);
    } catch (error, stackTrace) {
      throw toApiException(error, stackTrace);
    }
  }

  @override
  Future<Iterable<DiaryModel>> fetchDiaries({
    required String cursor, // created_at
    int limit = 20,
  }) async {
    try {
      return await _diaryView
          .select()
          .lt('created_at', cursor)
          .order('created_at', ascending: false)
          .limit(limit)
          .then((res) => res.map(DiaryModel.fromJson));
    } catch (error, stackTrace) {
      throw toApiException(error, stackTrace);
    }
  }

  @override
  Future<void> deleteDiaryById(String id, {bool isSoft = true}) async {
    try {
      if (isSoft) {
        final data = {'deleted_at': DateTime.now().toIso8601String()};
        await _diaryTable
            .update(data)
            .not('deleted_at', 'is', null)
            .eq('id', id);
      } else {
        await _diaryTable.delete().eq('id', id);
      }
    } catch (error, stackTrace) {
      throw toApiException(error, stackTrace);
    }
  }

  /// Story
  @override
  Future<StoryModel> insertStory({
    required String storyId,
    required String diaryId,
    required String description,
    int sequence = 0,
  }) async {
    try {
      final data = {
        'id': storyId,
        'diary_id': diaryId,
        'description': description,
        'sequence': sequence,
      };
      return await _storyTable
          .insert(data)
          .select()
          .single()
          .then(StoryModel.fromJson);
    } catch (error, stackTrace) {
      throw toApiException(error, stackTrace);
    }
  }

  @override
  Future<Iterable<StoryModel>> fetchStoriesByDiaryId({
    required String diaryId,
    required String cursor, // created_at
    int limit = 20,
  }) async {
    try {
      final query = "*, media:${SupabaseTables.media.name}(*)";
      return await _storyTable
          .select(query)
          .eq('diary_id', diaryId)
          .not('deleted_at', 'is', null) // 삭제된 데이터는 미조회
          .lt('created_at', cursor)
          .order('sequence', ascending: true)
          .order('created_at', ascending: false)
          .limit(limit)
          .then((res) => res.map(StoryModel.fromJson));
    } catch (error, stackTrace) {
      throw toApiException(error, stackTrace);
    }
  }

  @override
  Future<void> updateStory({
    required String storyId,
    required String description,
  }) async {
    try {
      final data = {'description': description};
      return await _storyTable
          .update(data)
          .eq('id', storyId)
          .not('deleted_at', 'is', null);
    } catch (error, stackTrace) {
      throw toApiException(error, stackTrace);
    }
  }

  @override
  Future<void> deleteStoryById(String storyId, {bool isSoft = true}) async {
    try {
      if (isSoft) {
        final data = {'deleted_at': DateTime.now().toIso8601String()};
        await _storyTable
            .update(data)
            .eq('id', storyId)
            .not('deleted_at', 'is', null);
      } else {
        await _storyTable.delete().eq('id', storyId);
      }
    } catch (error, stackTrace) {
      throw toApiException(error, stackTrace);
    }
  }

  /// Media
  @override
  Future<Iterable<StoryMediaModel>> insertMedia({
    required String diaryId,
    required String storyId,
    required Iterable<String> paths,
  }) async {
    try {
      final data = paths.indexed.map(
        (e) => {
          'diary_id': diaryId,
          'story_id': storyId,
          'sequence': e.$1,
          'path': e.$2,
        },
      );
      return await _mediaTable
          .insert(data)
          .select()
          .then((res) => res.map(StoryMediaModel.fromJson));
    } catch (error, stackTrace) {
      throw toApiException(error, stackTrace);
    }
  }

  @override
  Future<Iterable<String>> deleteMedia({
    required String diaryId,
    required String storyId,
    Iterable<int> sequences = const [],
    bool isSoft = true,
  }) async {
    try {
      if (sequences.isEmpty) {
        throw ApiException.badRequest(message: 'nothing to delete');
      }
      final paths = await _mediaTable
          .select()
          .eq('diary_id', diaryId)
          .eq('story_id', storyId)
          .not('deleted_at', 'is', null)
          .filter('sequence', 'in', sequences)
          .then((res) => res.map((json) => json['path'] as String));
      if (paths.isEmpty) {
        throw ApiException.badRequest(message: 'nothing to delete');
      }
      if (isSoft) {
        final data = {'deleted_at': DateTime.now().toIso8601String()};
        return await _mediaTable
            .update(data)
            .filter('path', 'in', paths)
            .then((_) => paths);
      } else {
        return await _mediaTable
            .delete()
            .filter('path', 'in', paths)
            .then((_) => paths);
      }
    } catch (error, stackTrace) {
      throw toApiException(error, stackTrace);
    }
  }
}
