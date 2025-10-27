import 'package:diary/data/datasoure/local/database/local_database.dart';
import 'package:diary/data/datasoure/local/database/local_database_dao.dart';

import 'package:drift/drift.dart';

import 'dto.dart';

part 'local_diary_datasource_impl.dart';

abstract interface class LocalDiaryDataSource {
  Future<DiaryRecord> create(CreateDiaryRequestDto dto);

  Future<DiaryRecord?> findById(String id);

  Future<List<DiaryRecord>> fetchRows({int limit = 20, int offset = 0});

  Future<List<DiaryRecord>> searchByTitle({
    required String keyword,
    int limit = 20,
    int offset = 0,
  });

  Stream<List<DiaryRecord>> watchAll();

  Future<DiaryRecord> update(UpdateDiaryRequestDto dto);

  Future<void> delete(String id);
}
