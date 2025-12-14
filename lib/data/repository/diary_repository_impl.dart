import 'dart:io';

import 'package:diary/core/response/api_response.dart';
import 'package:diary/data/mapper/diary_entity_mapper.dart';
import 'package:diary/data/mapper/story_entity_mapper.dart';
import 'package:diary/data/mapper/story_media_entity_mapper.dart';
import 'package:diary/data/repository/repository_response_handler.dart';
import 'package:diary/domain/entity/diary/diary_entity.dart';
import 'package:diary/domain/entity/diary/story_entity.dart';
import 'package:diary/domain/entity/diary/story_media_entity.dart';
import 'package:diary/domain/repository/diary_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:shared/shared.dart';
import 'package:supabase_datasource/export.dart';

@LazySingleton(as: DiaryRepository)
class DiaryRepositoryImpl
    with RepositoryResponseHandlerMixIn
    implements DiaryRepository {
  DiaryRepositoryImpl(this._database, this._storage, this._logger);

  final SupabaseDiaryDataSource _database;
  final SupabaseDiaryMediaBucketDataSource _storage;
  final Logger _logger;

  @override
  Future<ApiResponse<DiaryEntity>> insertDiary({
    String? clientDiaryId,
    String? title,
  }) async {
    try {
      final diaryId = clientDiaryId ?? genUuid();
      return await _database
          .insertDiary(diaryId: diaryId, title: title)
          .then((res) => res.toEntity())
          .then(apiSuccess<DiaryEntity>);
    } on ApiException catch (e, st) {
      return fromApiException(error: e, stackTrace: st, logger: _logger);
    }
  }

  @override
  Future<ApiResponse<List<DiaryEntity>>> fetchDiaries({
    required String cursor,
    int limit = 20,
  }) async {
    try {
      return await _database
          .fetchDiaries(cursor: cursor, limit: limit)
          .then((res) => res.map((e) => e.toEntity()).toList())
          .then(apiSuccess<List<DiaryEntity>>);
    } on ApiException catch (e, st) {
      return fromApiException(error: e, stackTrace: st, logger: _logger);
    }
  }

  @override
  Future<ApiResponse<void>> deleteDiary(String diaryId) async {
    try {
      await _database.deleteDiaryById(diaryId, isSoft: true);
      return apiSuccess<void>(null);
    } on ApiException catch (e, st) {
      return fromApiException(error: e, stackTrace: st, logger: _logger);
    }
  }

  @override
  Future<ApiResponse<StoryEntity>> insertStory({
    required String diaryId,
    String? clientStoryId,
    int sequence = 0,
    required String description,
  }) async {
    try {
      final storyId = clientStoryId ?? genUuid();
      return await _database
          .insertStory(
            diaryId: diaryId,
            storyId: storyId,
            sequence: sequence,
            description: description,
          )
          .then((res) => res.toEntity())
          .then(apiSuccess<StoryEntity>);
    } on ApiException catch (e, st) {
      return fromApiException(error: e, stackTrace: st, logger: _logger);
    }
  }

  @override
  Future<ApiResponse<List<StoryEntity>>> fetchStories({
    required String diaryId,
    required String cursor,
    int limit = 20,
  }) async {
    try {
      return await _database
          .fetchStoriesByDiaryId(diaryId: diaryId, cursor: cursor, limit: limit)
          .then((res) => res.map((e) => e.toEntity()).toList())
          .then(apiSuccess<List<StoryEntity>>);
    } on ApiException catch (e, st) {
      return fromApiException(error: e, stackTrace: st, logger: _logger);
    }
  }

  @override
  Future<ApiResponse<void>> deleteStory(String storyId) async {
    try {
      return await _database
          .deleteStoryById(storyId, isSoft: true)
          .then(apiSuccess<void>);
    } on ApiException catch (e, st) {
      return fromApiException(error: e, stackTrace: st, logger: _logger);
    }
  }

  @override
  Future<ApiResponse<List<StoryMediaEntity>>> insertMedia({
    required String diaryId,
    required String styroId,
    required Iterable<String> paths,
  }) async {
    try {
      return await _database
          .insertMedia(diaryId: diaryId, storyId: styroId, paths: paths)
          .then((res) => res.map((e) => e.toEntity()).toList())
          .then(apiSuccess<List<StoryMediaEntity>>);
    } on ApiException catch (e, st) {
      return fromApiException(error: e, stackTrace: st, logger: _logger);
    }
  }

  @override
  Future<ApiResponse<List<String>>> deleteMedia({
    required String diaryId,
    required String storyId,
    required Iterable<int> sequences,
  }) async {
    try {
      return await _database
          .deleteMedia(diaryId: diaryId, storyId: storyId, sequences: sequences)
          .then((res) => res.toList())
          .then(apiSuccess<List<String>>);
    } on ApiException catch (e, st) {
      return fromApiException(error: e, stackTrace: st, logger: _logger);
    }
  }

  @override
  Future<ApiResponse<List<String>>> uploadImagesOnBucket({
    required String diaryId,
    required String storyId,
    required Iterable<File> files,
  }) async {
    try {
      final futures = files.map(
        (file) => _storage.uploadMedia(
          diaryId: diaryId,
          storyId: storyId,
          media: file,
        ),
      );
      return await Future.wait(futures).then(apiSuccess<List<String>>);
    } on ApiException catch (e, st) {
      return fromApiException(error: e, stackTrace: st, logger: _logger);
    }
  }

  @override
  Future<ApiResponse<void>> deleteImagesOnBucket(List<String> paths) async {
    try {
      return await _storage.deleteMedia(paths).then(apiSuccess<void>);
    } on ApiException catch (e, st) {
      return fromApiException(error: e, stackTrace: st, logger: _logger);
    }
  }
}
