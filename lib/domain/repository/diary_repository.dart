import 'dart:io';

import 'package:diary/core/response/api_response.dart';
import 'package:diary/domain/entity/diary/diary_entity.dart';
import 'package:diary/domain/entity/diary/story_entity.dart';

abstract interface class DiaryRepository {
  Future<ApiResponse<DiaryEntity>> createDiary({
    String? clientDiaryId,
    String? title,
  });

  Future<ApiResponse<StoryEntity>> createStory({
    required String diaryId,
    String? clientStoryId,
    int sequence = 0,
    required String description,
    required Iterable<String> media,
  });

  Future<ApiResponse<Iterable<String>>> uploadStoryImages({
    required String diaryId,
  required  Iterable<File> files,
  });

  Future<ApiResponse<Iterable<DiaryEntity>>> fetchDiaries({
    required String cursor, // created_at
    int limit = 20,
  });

  Future<ApiResponse<DiaryWithStoryEntity>> getDiaryDetail(String diaryId);

  Future<ApiResponse<void>> deleteDiary(String diaryId);

  Future<ApiResponse<void>> deleteStory(String storyId);
}
