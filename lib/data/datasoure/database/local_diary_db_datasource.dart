import 'package:diary/data/datasoure/database/dao/local_database.dart';
import 'package:diary/data/datasoure/database/dao/local_database_dao.dart';

import 'package:logger/logger.dart';
import 'package:drift/drift.dart';

import 'dto.dart';

part 'local_diary_db_datasource_impl.dart';

abstract interface class LocalDiaryDbDataSource {
  Future<DiaryRecord> create(CreateDiaryRequestDto dto);

  Future<DiaryRecord?> findById(String id);

  Future<Iterable<DiaryRecord>> fetchRowsByCursor({
    int limit = 20,
    required DateTime cursor,
  });

  Future<Iterable<DiaryRecord>> searchByTitle({
    required String keyword,
    int limit = 20,
    required DateTime cursor,
  });

  Stream<List<DiaryRecord>> watchAll();

  Future<DiaryRecord> update(UpdateDiaryRequestDto dto);

  Future<List<DiaryMediaRecord>> fetchMedias(String diaryId);

  Future<DiaryMediaRecord?> findMediaByPath({
    required String diaryId,
    required String relativePath,
  });

  Future<DiaryMediaRecord> upsertMedia({
    required String diaryId,
    required CreateDiaryMediaRequestDto media,
  });

  Future<void> deleteMedia({
    required String diaryId,
    required String relativePath,
    bool ignoreMissing = true,
  });

  Future<void> deleteAllMedias(String diaryId);

  Future<void> delete(String id);
}
