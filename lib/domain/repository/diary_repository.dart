import 'dart:io';

import 'package:diary/core/response/api_response.dart';
import 'package:diary/domain/entity/diary/diary_entity.dart';
import 'package:diary/domain/entity/diary/story_entity.dart';
import 'package:diary/domain/entity/diary/story_media_entity.dart';

abstract interface class DiaryRepository {
  /// diary
  Future<ApiResponse<DiaryEntity>> insertDiary({
    String? clientDiaryId,
    String? title,
  });

  Future<ApiResponse<List<DiaryEntity>>> fetchDiaries({
    required String cursor, // created_at
    int limit = 20,
  });

  Future<ApiResponse<void>> deleteDiary(String diaryId);

  /// story
  Future<ApiResponse<StoryEntity>> insertStory({
    required String diaryId,
    String? clientStoryId,
    int sequence = 0,
    required String description,
  });

  Future<ApiResponse<List<StoryEntity>>> fetchStories({
    required String diaryId,
    required String cursor, // created_at
    int limit = 20,
  });

  Future<ApiResponse<void>> deleteStory(String storyId);

  /// media
  Future<ApiResponse<List<StoryMediaEntity>>> insertMedia({
    required String diaryId,
    required String styroId,
    required Iterable<String> paths,
  });

  Future<ApiResponse<List<String>>> deleteMedia({
    required String diaryId,
    required String storyId,
    required Iterable<int> sequences,
  });

  /// Bucket
  Future<ApiResponse<List<String>>> uploadImagesOnBucket({
    required String diaryId,
    required String storyId,
    required Iterable<File> files,
  });

  Future<ApiResponse<void>> deleteImagesOnBucket(List<String> paths);
}
