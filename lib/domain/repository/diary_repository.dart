import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:diary/core/value_objects/error/api_error.dart';
import 'package:diary/domain/entity/diary_detail_entity.dart';
import 'package:diary/domain/entity/diary_entity.dart';

part 'diary_repository_params.dart';

abstract interface class DiaryRepository {
  Future<Either<ApiError, DiaryEntity>> create({
    String? clientId,
    String? title,
    required String content,
    List<CreateDiaryMediaRequest> medias = const [],
  });

  Future<Either<ApiError, DiaryEntity?>> findById(String diaryId);

  Future<Either<ApiError, DiaryDetailEntity?>> getDiaryDetail(String diaryId);

  Future<Either<ApiError, List<DiaryEntity>>> fetchDiaries({
    int limit = 20,
    required DateTime cursor,
  });

  Future<Either<ApiError, List<DiaryEntity>>> searchByTitle({
    required String keyword,
    int limit = 20,
    required DateTime cursor,
  });

  Future<Either<ApiError, List<DiaryEntity>>> searchByContent({
    required String keyword,
    int limit = 20,
    required DateTime cursor,
  });

  Future<Either<ApiError, List<DiaryEntity>>> searchByDateRange({
    required DateTime start,
    required DateTime end,
    int limit = 20,
    required DateTime cursor,
  });

  Stream<Either<ApiError, List<DiaryEntity>>> watchAll();

  Future<Either<ApiError, DiaryEntity>> update({
    required String diaryId,
    String? title,
    required String content,
    List<CreateDiaryMediaRequest> medias = const [],
  });

  Future<Either<ApiError, void>> delete(String diaryId);

  Future<Either<ApiError, List<CreateDiaryMediaRequest>>> uploadMediaFiles({
    required String diaryId,
    required List<File> files,
  });
}
