import 'dart:io';

import 'package:diary/core/response/api_response.dart';
import 'package:diary/data/mapper/diary_entity_mapper.dart';
import 'package:diary/data/mapper/story_entity_mapper.dart';
import 'package:diary/data/repository/repository_response_handler.dart';
import 'package:diary/domain/entity/diary/diary_entity.dart';
import 'package:diary/domain/entity/diary/story_entity.dart';
import 'package:diary/domain/repository/diary_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:shared/shared.dart';
import 'package:supabase_datasource/export.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: DiaryRepository)
class DiaryRepositoryImpl
    with RepositoryResponseHandlerMixIn
    implements DiaryRepository {
  DiaryRepositoryImpl(this._auth, this._database, this._storage, this._logger);

  final SupabaseAuthDataSource _auth;
  final SupabaseDiaryDataSource _database;
  final SupabaseStoryBucketDataSource _storage;
  final Logger _logger;

  @override
  Future<ApiResponse<DiaryEntity>> createDiary({
    String? clientDiaryId,
    String? title,
  }) async {
    try {
      final diaryId = clientDiaryId ?? Uuid().v4();
      return await _database
          .createDiary(diaryId: diaryId, title: title)
          .then((res) => res.toEntity())
          .then(apiSuccess<DiaryEntity>);
    } on ApiException catch (e, st) {
      return fromApiException(error: e, stackTrace: st, logger: _logger);
    }
  }

  @override
  Future<ApiResponse<StoryEntity>> createStory({
    required String diaryId,
    String? clientStoryId,
    int sequence = 0,
    required String description,
    required Iterable<String> media,
  }) async {
    try {
      final storyId = clientStoryId ?? Uuid().v4();
      return await _database
          .createStory(
            diaryId: diaryId,
            storyId: storyId,
            sequence: sequence,
            description: description,
            media: media,
          )
          .then((res) => res.toEntity())
          .then(apiSuccess<StoryEntity>);
    } on ApiException catch (e, st) {
      return fromApiException(error: e, stackTrace: st, logger: _logger);
    }
  }

  @override
  Future<ApiResponse<Iterable<String>>> uploadStoryImages({
    required String diaryId,
    required Iterable<File> files,
  }) async {
    try {
      final currentUid = _auth.currentUser?.id;
      if (currentUid == null) {
        throw ApiException.unauthorized(message: 'current user not found');
      }

      final futures = files.mapWithIndex((file, index) async {
        final path = '$currentUid/$diaryId/$index.jpg';
        await _storage.uploadFile(path: path, file: file);
        return path;
      });

      return await Future.wait(futures).then(apiSuccess<Iterable<String>>);
    } on ApiException catch (e, st) {
      return fromApiException(error: e, stackTrace: st, logger: _logger);
    }
  }

  @override
  Future<ApiResponse<DiaryWithStoryEntity>> getDiaryDetail(
    String diaryId,
  ) async {
    try {
      return await _database
          .getDiaryDetail(diaryId)
          .then((res) => res.toEntity())
          .then(apiSuccess<DiaryWithStoryEntity>);
    } on ApiException catch (e, st) {
      return fromApiException(error: e, stackTrace: st, logger: _logger);
    }
  }

  @override
  Future<ApiResponse<Iterable<DiaryEntity>>> fetchDiaries({
    required String cursor,
    int limit = 20,
  }) async {
    try {
      return await _database
          .fetchDiaries(cursor: cursor, limit: limit)
          .then((res) => res.map((e) => e.toEntity()))
          .then(apiSuccess);
    } on ApiException catch (e, st) {
      return fromApiException(error: e, stackTrace: st, logger: _logger);
    }
  }

  @override
  Future<ApiResponse<void>> deleteDiary(String diaryId) async {
    try {
      await _database.deleteDiaryById(diaryId, isSoft: true);
    } on ApiException catch (e, st) {
      return fromApiException(error: e, stackTrace: st, logger: _logger);
    }

    try {
      await _database.deleteStoriesByDiaryId(diaryId, isSoft: true);
    } on ApiException catch (e, st) {
      _logger.w(
        'delete diary success, but delete its stories failed',
        error: e,
        stackTrace: st,
      );
    }

    return apiSuccess<void>(null);
  }

  @override
  Future<ApiResponse<void>> deleteStory(String storyId) async {
    try {
      return await _database
          .deleteStoriesByDiaryId(storyId, isSoft: true)
          .then(apiSuccess<void>);
    } on ApiException catch (e, st) {
      return fromApiException(error: e, stackTrace: st, logger: _logger);
    }
  }
}
