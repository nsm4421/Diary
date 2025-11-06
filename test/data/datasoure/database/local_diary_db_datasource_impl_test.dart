import 'package:diary/data/datasoure/database/dao/local_database.dart';
import 'package:diary/data/datasoure/database/dao/local_database_dao.dart';
import 'package:diary/data/datasoure/database/dto.dart';
import 'package:diary/data/datasoure/database/local_diary_db_datasource.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mock_logger.dart';

class _DiarySeed {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  const _DiarySeed({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });
}

void main() {
  late LocalDatabase db;
  late LocalDatabaseDao dao;
  late MockLogger logger;
  late LocalDiaryDbDataSource dataSource;
  var autoId = 0;

  Future<_DiarySeed> insertDiary({
    String? id,
    String title = 'title',
    String content = 'content',
    DateTime? createdAt,
    DateTime? updatedAt,
  }) async {
    final effectiveId = id ?? 'id-${autoId++}';
    final created = createdAt ?? DateTime.now().toUtc();
    final updated = updatedAt ?? created;

    await db
        .into(db.diaryRecords)
        .insert(
          DiaryRecordsCompanion.insert(
            id: Value(effectiveId),
            title: Value(title),
            content: content,
            createdAt: Value(created),
            updatedAt: Value(updated),
            date: Value(created.toIso8601String()),
          ),
        );

    return _DiarySeed(id: effectiveId, createdAt: created, updatedAt: updated);
  }

  Future<DiaryRecord> recordById(String id) {
    final query = db.select(db.diaryRecords)..where((tbl) => tbl.id.equals(id));
    return query.getSingle();
  }

  Future<List<DiaryMediaRecord>> mediaByDiaryId(String diaryId) {
    final query = db.select(db.diaryMediaRecords)
      ..where((tbl) => tbl.diaryId.equals(diaryId))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)]);
    return query.get();
  }

  setUp(() {
    autoId = 0;
    db = LocalDatabase.test();
    dao = LocalDatabaseDao(db);
    logger = MockLogger();
    dataSource = LocalDiaryDbSourceImpl(dao, logger);
  });

  tearDown(() async {
    await db.close();
  });

  group('create', () {
    test('does not create media rows when media list empty', () async {
      final dto = CreateDiaryRequestDto(
        clientId: 'no-media',
        title: 'Entry without attachments',
        content: 'Plain content',
        medias: const [],
      );

      await dataSource.create(dto);

      final mediaRows = await mediaByDiaryId(dto.id);
      expect(mediaRows, isEmpty);
    });

    test('persists a new diary row', () async {
      final dto = CreateDiaryRequestDto(
        clientId: 'create-id',
        title: 'First title',
        content: 'First content',
      );

      await dataSource.create(dto);

      final row = await recordById(dto.id);
      expect(row.title, dto.title);
      expect(row.content, dto.content);
    });

    test('persists related media rows when provided', () async {
      final dto = CreateDiaryRequestDto(
        clientId: 'with-media',
        title: 'Entry with photos',
        content: 'Content',
        medias: const [
          CreateDiaryMediaRequestDto(
            relativePath: 'diary/with-media/0.jpg',
            fileName: '0.jpg',
            mimeType: 'image/jpeg',
            sizeInBytes: 1024,
            width: 800,
            height: 600,
            sortOrder: 5,
          ),
          CreateDiaryMediaRequestDto(
            relativePath: 'diary/with-media/1.jpg',
            fileName: '1.jpg',
          ),
        ],
      );

      await dataSource.create(dto);

      final mediaRows = await mediaByDiaryId(dto.id);
      expect(mediaRows, hasLength(2));
      final primary = mediaRows.singleWhere(
        (row) => row.relativePath == dto.medias.first.relativePath,
      );
      final secondary = mediaRows.singleWhere(
        (row) => row.relativePath == dto.medias[1].relativePath,
      );
      expect(primary.diaryId, dto.id);
      expect(primary.mimeType, dto.medias.first.mimeType);
      expect(primary.sortOrder, dto.medias.first.sortOrder);
      expect(secondary.sortOrder, 1);
      expect(secondary.mimeType, isNull);
    });
  });

  group('fetchRowsByCursor', () {
    test('returns rows ordered by createdAt desc for first page', () async {
      final oldest = await insertDiary(
        id: 'old',
        createdAt: DateTime(2024, 1, 1),
      );
      final middle = await insertDiary(
        id: 'mid',
        createdAt: DateTime(2024, 1, 2),
      );
      final newest = await insertDiary(
        id: 'new',
        createdAt: DateTime(2024, 1, 3),
      );

      final rows = await dataSource.fetchRowsByCursor(
        limit: 2,
        cursor: DateTime(2024, 1, 4),
      );

      expect(rows.map((r) => r.id), [newest.id, middle.id]);
    });

    test('returns rows older than provided cursor', () async {
      final oldest = await insertDiary(
        id: 'old',
        createdAt: DateTime(2024, 1, 1),
      );
      final middle = await insertDiary(
        id: 'mid',
        createdAt: DateTime(2024, 1, 2),
      );
      await insertDiary(
        id: 'new',
        createdAt: DateTime(2024, 1, 3),
      );

      final rows = await dataSource.fetchRowsByCursor(
        limit: 5,
        cursor: middle.createdAt,
      );

      expect(rows.map((r) => r.id), [oldest.id]);
    });
  });

  group('findById', () {
    test('returns matching record when row exists', () async {
      final seed = await insertDiary(id: 'find-me');

      final record = await dataSource.findById(seed.id);

      expect(record, isNotNull);
      expect(record!.id, seed.id);
    });

    test('returns null when row does not exist', () async {
      final record = await dataSource.findById('missing-id');
      expect(record, isNull);
    });
  });

  group('searchByTitle', () {
    test('filters rows by keyword and orders by createdAt', () async {
      final older = await insertDiary(
        id: 'sunrise',
        title: 'Morning Sun',
        createdAt: DateTime(2024, 1, 1),
      );
      final latest = await insertDiary(
        id: 'sunset',
        title: 'Cool Sunset',
        createdAt: DateTime(2024, 2, 1),
      );
      await insertDiary(
        id: 'rain',
        title: 'Rain day',
        createdAt: DateTime(2024, 3, 1),
      );

      final rows = await dataSource.searchByTitle(
        keyword: ' sun ',
        cursor: DateTime(2024, 3, 2),
      );

      expect(rows.map((r) => r.id), [latest.id, older.id]);
    });
  });

  group('update', () {
    test('updates row content and timestamp', () async {
      final seed = await insertDiary(
        id: 'update-id',
        title: 'Old',
        content: 'Old content',
        updatedAt: DateTime.utc(2000, 1, 1),
      );

      final dto = UpdateDiaryRequestDto(
        id: seed.id,
        title: 'New title',
        content: 'New body',
      );

      await dataSource.update(dto);

      final updated = await recordById(seed.id);
      expect(updated.title, dto.title);
      expect(updated.content, dto.content);
      expect(updated.updatedAt, isNot(equals(seed.updatedAt)));
    });

    test('throws when row missing', () async {
      final dto = UpdateDiaryRequestDto(
        id: 'missing',
        title: 'none',
        content: 'none',
      );

      await expectLater(dataSource.update(dto), throwsStateError);
    });
  });

  group('delete', () {
    test('removes matching row', () async {
      final seed = await insertDiary();

      await dataSource.delete(seed.id);

      final rows = await db.select(db.diaryRecords).get();
      expect(rows, isEmpty);
    });

    test('removes related media rows', () async {
      final seed = await insertDiary();
      await db.into(db.diaryMediaRecords).insert(
            DiaryMediaRecordsCompanion.insert(
              diaryId: seed.id,
              relativePath: 'diary/${seed.id}/0.jpg',
              fileName: '0.jpg',
            ),
          );

      await dataSource.delete(seed.id);

      final mediaRows = await db.select(db.diaryMediaRecords).get();
      expect(mediaRows, isEmpty);
    });

    test('throws when row not found', () async {
      await expectLater(dataSource.delete('missing'), throwsStateError);
    });
  });
}
