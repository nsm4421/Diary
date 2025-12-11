part of 'diary_datasource.dart';

class SupabaseDiaryDataSourceImpl
    with SupabaseDataSourceExceptionHandlerMixIn
    implements SupabaseDiaryDataSource {
  final SupabaseClient _client;

  SupabaseDiaryDataSourceImpl(this._client);

  String get _currentUid => _client.auth.currentUser!.id;

  PostgrestQueryBuilder get _diaryTable =>
      _client.from(SupabaseTables.diary.name);

  PostgrestQueryBuilder get _storyTable =>
      _client.from(SupabaseTables.story.name);

  /// Diary
  @override
  Future<DiaryModel> createDiary({
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
      return await _diaryTable
          .select()
          .eq('created_by', _currentUid)
          .lt('created_at', cursor)
          .order('created_at', ascending: false)
          .limit(limit)
          .then((res) => res.map(DiaryModel.fromJson));
    } catch (error, stackTrace) {
      throw toApiException(error, stackTrace);
    }
  }

  @override
  Future<DiaryDetailModel> getDiaryDetail(String diaryId) async {
    try {
      final query = "*, stories:${SupabaseTables.story.name}(*)";
      return await _diaryTable
          .select(query)
          .eq('id', diaryId)
          .single()
          .then(DiaryDetailModel.fromJson);
    } catch (error, stackTrace) {
      throw toApiException(error, stackTrace);
    }
  }

  @override
  Future<void> deleteDiaryById(String id, {bool isSoft = true}) async {
    try {
      if (isSoft) {
        final data = {'deleted_at': DateTime.now().toIso8601String()};
        await _diaryTable.update(data).eq('id', id);
      } else {
        await _diaryTable.delete().eq('id', id);
      }
    } catch (error, stackTrace) {
      throw toApiException(error, stackTrace);
    }
  }

  /// Story
  @override
  Future<StoryModel> createStory({
    required String storyId,
    required String diaryId,
    required String description,
    int sequence = 0,
    required Iterable<String> media,
  }) async {
    try {
      final data = {
        'id': storyId,
        'diary_id': diaryId,
        'description': description,
        'sequence': sequence,
        'media': media,
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
  Future<Iterable<StoryModel>> fetchStoriesByDiaryId(String diaryId) async {
    try {
      return await _storyTable
          .select()
          .eq('diary_id', diaryId)
          .order('sequence', ascending: true)
          .order('created_at', ascending: false)
          .then((res) => res.map(StoryModel.fromJson));
    } catch (error, stackTrace) {
      throw toApiException(error, stackTrace);
    }
  }

  @override
  Future<void> updateStory({
    required String storyId,
    required String description,
    required List<String> media,
  }) async {
    try {
      final data = {'description': description, 'media': media};
      return await _storyTable.update(data).eq('id', storyId);
    } catch (error, stackTrace) {
      throw toApiException(error, stackTrace);
    }
  }

  @override
  Future<void> deleteStoriesByDiaryId(
    String diaryId, {
    bool isSoft = true,
  }) async {
    try {
      if (isSoft) {
        final data = {'deleted_at': DateTime.now().toIso8601String()};
        await _storyTable.update(data).eq('diary_id', diaryId);
      } else {
        await _storyTable.delete().eq('diary_id', diaryId);
      }
    } catch (error, stackTrace) {
      throw toApiException(error, stackTrace);
    }
  }

  @override
  Future<void> deleteStoryById(String storyId, {bool isSoft = true}) async {
    try {
      if (isSoft) {
        final data = {'deleted_at': DateTime.now().toIso8601String()};
        await _storyTable.update(data).eq('id', storyId);
      } else {
        await _storyTable.delete().eq('id', storyId);
      }
    } catch (error, stackTrace) {
      throw toApiException(error, stackTrace);
    }
  }
}
