import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/tables.dart';
import '../../model/diary/diary_detail_model.dart';
import '../../model/diary/diary_model.dart';
import '../../model/diary/story_model.dart';
import '../../utils/datasource_exception_handler.dart';

part 'diary_datasource_impl.dart';

abstract interface class SupabaseDiaryDataSource {
  /// Diary
  Future<DiaryModel> createDiary({required String diaryId, String? title});

  Future<Iterable<DiaryModel>> fetchDiaries({
    required String cursor, // created_at
    int limit = 20,
  });

  Future<DiaryDetailModel> getDiaryDetail(String diaryId);

  Future<void> deleteDiaryById(String id, {bool isSoft = true});

  /// Story
  Future<StoryModel> createStory({
    required String storyId,
    required String diaryId,
    required String description,
    int sequence = 0,
    required Iterable<String> media,
  });

  Future<Iterable<StoryModel>> fetchStoriesByDiaryId(String diaryId);

  Future<void> updateStory({
    required String storyId,
    required String description,
    required List<String> media,
  });

  Future<void> deleteStoriesByDiaryId(String diaryId, {bool isSoft = true});

  Future<void> deleteStoryById(String storyId, {bool isSoft = true});
}
