part of 'local_diary_datasource.dart';

class LocalDiaryDataSourceImpl implements LocalDiaryDataSource {
  final LocalDatabaseDao _dao;
  final Logger _logger;
  LocalDiaryDataSourceImpl(this._dao, this._logger);

  @override
  Future<DiaryRecord> create(CreateDiaryRequestDto dto) async {
    try {
      return await _dao.transaction(() async {
        // insert
        await _dao
            .into(_dao.db.diaryRecords)
            .insert(
              DiaryRecordsCompanion.insert(
                id: Value(dto.id),
                title: Value(dto.title),
                content: dto.content,
              ),
            );
        final findQuery = _dao.select(_dao.db.diaryRecords)
          ..where((tbl) => tbl.id.equals(dto.id));
        return findQuery.getSingle();
      });
    } catch (e, st) {
      _logger.e(e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<DiaryRecord>> fetchRowsByCursor({
    int limit = 20,
    required DateTime cursor,
  }) {
    try {
      final fetchQuery = _dao.select(_dao.db.diaryRecords, distinct: true)
        ..where((tbl) => tbl.createdAt.isSmallerThanValue(cursor))
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])
        ..limit(limit);
      return fetchQuery.get();
    } catch (e, st) {
      _logger.e(e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<DiaryRecord?> findById(String id) async {
    try {
      final findQuery = _dao.select(_dao.db.diaryRecords)
        ..where((tbl) => tbl.id.equals(id));
      return findQuery.getSingleOrNull();
    } catch (e, st) {
      _logger.e(e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<DiaryRecord>> searchByTitle({
    required String keyword,
    int limit = 20,
    required DateTime cursor,
  }) async {
    try {
      final query = _dao.select(_dao.db.diaryRecords)
        ..where((tbl) => tbl.title.like('%${keyword.trim()}%'))
        ..where((tbl) => tbl.createdAt.isSmallerThanValue(cursor))
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])
        ..limit(limit);
      return await query.get();
    } catch (e, st) {
      _logger.e(e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Stream<List<DiaryRecord>> watchAll() {
    try {
      final query = _dao.select(_dao.db.diaryRecords)
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]);
      return query.watch();
    } catch (e, st) {
      _logger.e(e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<DiaryRecord> update(UpdateDiaryRequestDto dto) async {
    try {
      return await _dao.transaction(() async {
        final updateQuery = _dao.update(_dao.db.diaryRecords)
          ..where((tbl) => tbl.id.equals(dto.id));
        final updatedRowCount = await updateQuery.write(
          DiaryRecordsCompanion(
            title: Value(dto.title),
            content: Value(dto.content),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );
        if (updatedRowCount != 1) {
          throw StateError('update request affect $updatedRowCount rows');
        }
        // find by id
        final findQuery = _dao.select(_dao.db.diaryRecords)
          ..where((tbl) => tbl.id.equals(dto.id));
        return findQuery.getSingle();
      });
    } catch (e, st) {
      _logger.e(e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      return await _dao.transaction(() async {
        final deleteQuery = _dao.delete(_dao.db.diaryRecords)
          ..where((tbl) => tbl.id.equals(id));
        final affectedRowCount = await deleteQuery.go();
        if (affectedRowCount != 1) {
          throw StateError('delete request affect $affectedRowCount rows');
        }
      });
    } catch (e, st) {
      _logger.e(e, stackTrace: st);
      rethrow;
    }
  }
}
