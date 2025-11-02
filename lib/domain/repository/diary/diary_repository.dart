import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:diary/core/error/failure.dart';
import 'package:diary/domain/entity/diary_entry.dart';

part 'params.dart';

abstract interface class DiaryRepository {
  Future<Either<Failure, DiaryEntity>> create({
    String? clientId,
    String? title,
    required String content,
    List<CreateDiaryMediaRequest> medias = const [],
  });

  Future<Either<Failure, DiaryEntity?>> findById(String diaryId);

  Future<Either<Failure, List<DiaryEntity>>> fetchEntries({
    int limit = 20,
    required DateTime cursor,
  });

  Future<Either<Failure, List<DiaryEntity>>> searchByTitle({
    required String keyword,
    int limit = 20,
    required DateTime cursor,
  });

  Stream<Either<Failure, List<DiaryEntity>>> watchAll();

  Future<Either<Failure, DiaryEntity>> update({
    required String diaryId,
    String? title,
    required String content,
    List<CreateDiaryMediaRequest> medias = const [],
  });

  Future<Either<Failure, void>> delete(String diaryId);

  Future<Either<Failure, List<String>>> uploadMediaFiles({
    required String diaryId,
    required List<File> files,
  });
}
