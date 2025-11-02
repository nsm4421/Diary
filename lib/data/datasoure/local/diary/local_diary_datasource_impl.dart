part of 'local_diary_datasource.dart';

class LocalDiaryDataSourceImpl implements LocalDiaryDataSource {
  final LocalDatabaseDao _dao;
  final Logger _logger;
  LocalDiaryDataSourceImpl(this._dao, this._logger);

  @override
  Future<DiaryRecord> create(CreateDiaryRequestDto dto) async {
    try {
      return await _dao.transaction(() async {
        // insert on diary table
        await _dao.into(_dao.db.diaryRecords).insert(dto.toDiaryInsertable());

        // insert on diary media table
        if (dto.medias.isNotEmpty) {
          await _dao.batch((batch) {
            batch.insertAll(
              _dao.db.diaryMediaRecords,
              dto.toDiaryMediaInsertable().toList(growable: false),
            );
          });
        }

        // return created
        return (_dao.select(
          _dao.db.diaryRecords,
        )..where((tbl) => tbl.id.equals(dto.id))).getSingle();
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
  }) async {
    try {
      return await (_dao.select(_dao.db.diaryRecords, distinct: true)
            ..where((tbl) => tbl.createdAt.isSmallerThanValue(cursor))
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])
            ..limit(limit))
          .get();
    } catch (e, st) {
      _logger.e(e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<DiaryRecord?> findById(String id) async {
    try {
      return await (_dao.select(
        _dao.db.diaryRecords,
      )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
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
      return await (_dao.select(_dao.db.diaryRecords)
            ..where((tbl) => tbl.title.like('%${keyword.trim()}%'))
            ..where((tbl) => tbl.createdAt.isSmallerThanValue(cursor))
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])
            ..limit(limit))
          .get();
    } catch (e, st) {
      _logger.e(e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Stream<List<DiaryRecord>> watchAll() {
    try {
      return (_dao.select(
        _dao.db.diaryRecords,
      )..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])).watch();
    } catch (e, st) {
      _logger.e(e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<DiaryRecord> update(UpdateDiaryRequestDto dto) async {
    try {
      return await _dao.transaction(() async {
        // uddate diary table
        await (_dao.update(_dao.db.diaryRecords)
              ..where((tbl) => tbl.id.equals(dto.id)))
            .write(dto.toDiaryInsertable())
            .then((affectedRowCount) {
              if (affectedRowCount != 1) {
                throw StateError(
                  'update request affect $affectedRowCount rows',
                );
              }
            });

        // update diary medias
        await (_dao.delete(
          _dao.db.diaryMediaRecords,
        )..where((tbl) => tbl.diaryId.equals(dto.id))).go();
        if (dto.medias.isNotEmpty) {
          await _dao.batch((batch) {
            batch.insertAll(
              _dao.db.diaryMediaRecords,
              dto.toDiaryMediaInsertable().toList(growable: false),
            );
          });
        }

        // find by id
        return (_dao.select(
          _dao.db.diaryRecords,
        )..where((tbl) => tbl.id.equals(dto.id))).getSingle();
      });
    } catch (e, st) {
      _logger.e(e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<DiaryMediaRecord>> fetchMedias(String diaryId) async {
    try {
      final query = _dao.select(_dao.db.diaryMediaRecords)
        ..where((tbl) => tbl.diaryId.equals(diaryId))
        ..orderBy([
          (tbl) => OrderingTerm.asc(tbl.sortOrder),
          (tbl) => OrderingTerm.asc(tbl.createdAt),
        ]);
      return query.get();
    } catch (e, st) {
      _logger.e(e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<DiaryMediaRecord?> findMediaByPath({
    required String diaryId,
    required String relativePath,
  }) async {
    try {
      final query = _dao.select(_dao.db.diaryMediaRecords)
        ..where(
          (tbl) =>
              tbl.diaryId.equals(diaryId) &
              tbl.relativePath.equals(relativePath),
        );
      return query.getSingleOrNull();
    } catch (e, st) {
      _logger.e(e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<DiaryMediaRecord> upsertMedia({
    required String diaryId,
    required CreateDiaryMediaRequestDto media,
  }) async {
    try {
      return await _dao.transaction(() async {
        final existing = await findMediaByPath(
          diaryId: diaryId,
          relativePath: media.relativePath,
        );
        if (existing == null) {
          await _dao.into(_dao.db.diaryMediaRecords).insert(
                media.toInsertable(diaryId: diaryId),
              );
        } else {
          final query = _dao.update(_dao.db.diaryMediaRecords)
            ..where((tbl) => tbl.id.equals(existing.id));
          await query.write(
            media.toUpdateCompanion(
              fallbackSortOrder: existing.sortOrder,
            ),
          );
        }

        return (_dao.select(_dao.db.diaryMediaRecords)
              ..where(
                (tbl) =>
                    tbl.diaryId.equals(diaryId) &
                    tbl.relativePath.equals(media.relativePath),
              ))
            .getSingle();
      });
    } catch (e, st) {
      _logger.e(e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> deleteMedia({
    required String diaryId,
    required String relativePath,
    bool ignoreMissing = true,
  }) async {
    try {
      final deleteQuery = _dao.delete(_dao.db.diaryMediaRecords)
        ..where(
          (tbl) =>
              tbl.diaryId.equals(diaryId) &
              tbl.relativePath.equals(relativePath),
        );
      final affected = await deleteQuery.go();
      if (affected == 0 && !ignoreMissing) {
        throw StateError(
          'media not found for diaryId=$diaryId path=$relativePath',
        );
      }
    } catch (e, st) {
      _logger.e(e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> deleteAllMedias(String diaryId) async {
    try {
      await (_dao.delete(_dao.db.diaryMediaRecords)
            ..where((tbl) => tbl.diaryId.equals(diaryId)))
          .go();
    } catch (e, st) {
      _logger.e(e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      return await _dao.transaction(() async {
        // delete diary media table
        await (_dao.delete(
          _dao.db.diaryMediaRecords,
        )..where((tbl) => tbl.diaryId.equals(id))).go();

        // delete diary table
        await (_dao.delete(
          _dao.db.diaryRecords,
        )..where((tbl) => tbl.id.equals(id))).go().then((affectedRowCount) {
          if (affectedRowCount != 1) {
            throw StateError('delete request affect $affectedRowCount rows');
          }
        });
      });
    } catch (e, st) {
      _logger.e(e, stackTrace: st);
      rethrow;
    }
  }
}
