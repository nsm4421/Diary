import 'package:shared/shared.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/tables.dart';
import '../../model/diary/diary_model.dart';
import '../../model/diary/story_media_model.dart';
import '../../model/diary/story_model.dart';
import '../../utils/datasource_exception_handler.dart';
import '../../utils/diary_media_util.dart';

part 'diary_datasource_impl.dart';

abstract interface class SupabaseDiaryDataSource {
  /// Diary
  Future<DiaryModel> insertDiary({required String diaryId, String? title});

  Future<Iterable<DiaryModel>> fetchDiaries({
    required String cursor, // created_at
    int limit = 20,
  });

  Future<void> deleteDiaryById(String diaryId, {bool isSoft = true});

  /// Story
  Future<StoryModel> insertStory({
    required String diaryId,
    required String storyId,
    required String description,
    int sequence = 0,
  });

  Future<Iterable<StoryModel>> fetchStoriesByDiaryId({
    required String diaryId,
    required String cursor, // created_at
    int limit = 20,
  });

  Future<void> updateStory({
    required String storyId,
    required String description,
  });

  Future<void> deleteStoryById(String storyId, {bool isSoft = true});

  /// Media
  Future<Iterable<StoryMediaModel>> insertMedia({
    required String diaryId,
    required String storyId,
    required Iterable<String> paths,
  });

  Future<Iterable<String>>  deleteMedia({
    required String diaryId,
    required String storyId,
    Iterable<int> sequences = const [],
    bool isSoft = true,
  });
}
