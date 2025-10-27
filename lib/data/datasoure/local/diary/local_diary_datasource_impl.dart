part of 'local_diary_datasource.dart';

class LocalDiaryDataSourceImpl implements LocalDiaryDataSource {
  final LocalDatabaseDao _dao;
  LocalDiaryDataSourceImpl(this._dao);

  @override
  Future<DiaryRecord> create(CreateDiaryRequestDto dto) async =>
      await _dao.transaction(() async {
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
        // find by id
        return await (_dao.select(
          _dao.db.diaryRecords,
        )..where((tbl) => tbl.id.equals(dto.id))).getSingle();
      });

  @override
  Future<List<DiaryRecord>> fetchRows({int limit = 20, int offset = 0}) async =>
      await (_dao.select(_dao.db.diaryRecords)
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])
            ..limit(limit, offset: offset))
          .get();

  @override
  Future<DiaryRecord?> findById(String id) async => await (_dao.select(
    _dao.db.diaryRecords,
  )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  @override
  Future<List<DiaryRecord>> searchByTitle({
    required String keyword,
    int limit = 20,
    int offset = 0,
  }) async =>
      await (_dao.select(_dao.db.diaryRecords)
            ..where((tbl) => tbl.title.like('%${keyword.trim()}%'))
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])
            ..limit(limit, offset: offset))
          .get();

  @override
  Stream<List<DiaryRecord>> watchAll() => (_dao.select(
    _dao.db.diaryRecords,
  )..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])).watch();

  @override
  Future<DiaryRecord> update(UpdateDiaryRequestDto dto) async =>
      await _dao.transaction(() async {
        // update
        final affectedRowCount =
            await (_dao.update(
              _dao.db.diaryRecords,
            )..where((tbl) => tbl.id.equals(dto.id))).write(
              DiaryRecordsCompanion(
                title: Value(dto.title),
                content: Value(dto.content),
                updatedAt: Value(DateTime.now().toUtc()),
              ),
            );
        if (affectedRowCount != 1) {
          throw StateError('update request affect $affectedRowCount rows');
        }
        // find by id
        return await (_dao.select(
          _dao.db.diaryRecords,
        )..where((tbl) => tbl.id.equals(dto.id))).getSingle();
      });

  @override
  Future<void> delete(String id) async => await _dao.transaction(() async {
    final affectedRowCount = await (_dao.delete(
      _dao.db.diaryRecords,
    )..where((tbl) => tbl.id.equals(id))).go();
    if (affectedRowCount != 1) {
      throw StateError('delete request affect $affectedRowCount rows');
    }
  });
}
