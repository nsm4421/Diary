import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:diary/core/constant/api_error_code.dart';
import 'package:diary/core/value_objects/error/api_error.dart';
import 'package:diary/core/value_objects/error/api_exception.dart';
import 'package:diary/core/value_objects/domain/diary_mood.dart';
import 'package:diary/core/extension/datetime_extension.dart';
import 'package:diary/data/datasoure/database/dao/local_database.dart';
import 'package:diary/data/datasoure/database/dao/local_database_dao.dart';
import 'package:diary/data/datasoure/database/dto.dart';
import 'package:diary/data/datasoure/database/local_diary_db_datasource.dart';
import 'package:diary/data/datasoure/fs/local_diary_fs_datasource.dart';
import 'package:diary/data/datasoure/fs/local_fs_datasource.dart';
import 'package:diary/data/repository/diary_repository_impl.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:image/image.dart' as img;
import '../../mock_logger.dart';

void main() {
  late LocalDatabase db;
  late LocalDatabaseDao dao;
  late MockLogger logger;
  late LocalDiaryDbDataSource diaryDataSource;
  late LocalFileSystemDataSource storageDataSource;
  late LocalDiaryFsDataSource diaryStorage;
  late DiaryRepositoryImpl repository;
  late Directory storageRoot;
  late Directory inputDir;

  setUp(() async {
    db = LocalDatabase.test();
    dao = LocalDatabaseDao(db);
    logger = MockLogger();
    diaryDataSource = LocalDiaryDbSourceImpl(dao, logger);
    storageRoot = await Directory.systemTemp.createTemp('diary_repo_test');
    storageDataSource = LocalFileSystemDataSourceImpl(
      baseDirectory: storageRoot,
      logger: logger,
    );
    diaryStorage = LocalDiaryFsStorageImpl(storageDataSource);
    repository = DiaryRepositoryImpl(diaryDataSource, diaryStorage)
      ..setLogger(logger);
    inputDir = await Directory.systemTemp.createTemp('diary_repo_input');
  });

  tearDown(() async {
    await db.close();
    if (await storageRoot.exists()) {
      await storageRoot.delete(recursive: true);
    }
    if (await inputDir.exists()) {
      await inputDir.delete(recursive: true);
    }
  });

  Future<void> insertDiary({
    required String id,
    String? title = 'Seed title',
    String content = 'Seed content',
    DateTime? createdAt,
    DateTime? updatedAt,
  }) async {
    final created = createdAt ?? DateTime.now().toUtc();
    final updated = updatedAt ?? created;

    await db
        .into(db.diaryRecords)
        .insert(
          DiaryRecordsCompanion.insert(
            id: Value(id),
            title: Value(title),
            content: content,
            createdAt: Value(created),
            updatedAt: Value(updated),
            date: Value(created.yyyymmdd),
          ),
        );
  }

  Future<DiaryRecord> recordById(String id) {
    final query = db.select(db.diaryRecords)..where((tbl) => tbl.id.equals(id));
    return query.getSingle();
  }

  Future<List<DiaryMediaRecord>> mediaRecords(String diaryId) {
    final query = db.select(db.diaryMediaRecords)
      ..where((tbl) => tbl.diaryId.equals(diaryId))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)]);
    return query.get();
  }

  File fileAt(String relativePath) =>
      File(p.join(storageRoot.path, 'storage', relativePath));

  String absolutePath(String relativePath) =>
      p.join(storageRoot.path, 'storage', relativePath);

  Future<File> createTempFile(String name, Uint8List bytes) async {
    final file = File(p.join(inputDir.path, name));
    await file.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Uint8List imageBytes({int width = 4, int height = 3}) {
    final image = img.Image(width: width, height: height);
    return Uint8List.fromList(img.encodePng(image));
  }

  ApiError expectLeft<E>(Either<ApiError, E> either) {
    return either.fold(
      (error) => error,
      (_) => fail('Expected Left but got Right'),
    );
  }

  group('create', () {
    test('returns entity and persists row', () async {
      final result = await repository.create(
        clientId: 'create-id',
        title: 'First',
        content: 'First body',
      );

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected Right'), (entry) {
        expect(entry.id, 'create-id');
        expect(entry.title, 'First');
        expect(entry.content, 'First body');
      });

      final row = await recordById('create-id');
      expect(row.title, 'First');
      expect(row.content, 'First body');
    });

    test('returns ApiError when datasource throws ApiException', () async {
      final failingRepo = DiaryRepositoryImpl(
        _FailingCreateDataSource(ApiException.cache(message: 'failed')),
        diaryStorage,
      )..setLogger(logger);

      final result = await failingRepo.create(content: 'body');
      final error = expectLeft(result);
      expect(error.code, ApiErrorCode.cache);
      expect(error.message, 'failed');
    });
  });

  group('read operations', () {
    test('findById returns Right entry when found', () async {
      await insertDiary(id: 'find-me', title: 'My title', content: 'My body');

      final result = await repository.findById('find-me');
      result.fold((_) => fail('Expected Right'), (entry) {
        expect(entry, isNotNull);
        expect(entry!.id, 'find-me');
        expect(entry.title, 'My title');
      });
    });

    test('getDiaryDetail returns detail with medias', () async {
      await insertDiary(id: 'detail-id', title: 'Title');
      await db.into(db.diaryMediaRecords).insert(
            DiaryMediaRecordsCompanion.insert(
              diaryId: 'detail-id',
              relativePath: 'diary/detail-id/0001_photo.jpg',
              fileName: 'photo.jpg',
              sortOrder: const Value(2),
              width: const Value(400),
              height: const Value(300),
            ),
          );
      await db.into(db.diaryMediaRecords).insert(
            DiaryMediaRecordsCompanion.insert(
              diaryId: 'detail-id',
              relativePath: 'diary/detail-id/0000_cover.jpg',
              fileName: 'cover.jpg',
              sortOrder: const Value(1),
              sizeInBytes: const Value(1024),
            ),
          );

      final result = await repository.getDiaryDetail('detail-id');

      result.fold((_) => fail('Expected Right'), (entry) {
        expect(entry, isNotNull);
        final detail = entry!;
        expect(detail.id, 'detail-id');
        expect(detail.medias.length, 2);
        expect(detail.medias.map((m) => m.fileName), ['cover.jpg', 'photo.jpg']);
        expect(
          detail.medias.map((m) => m.absolutePath),
          [
            absolutePath('diary/detail-id/0000_cover.jpg'),
            absolutePath('diary/detail-id/0001_photo.jpg'),
          ],
        );
        final cover = detail.medias.first;
        expect(cover.sizeInBytes, 1024);
        final photo = detail.medias.last;
        expect(photo.width, 400);
        expect(photo.height, 300);
      });
    });

    test('getDiaryDetail returns ApiError when record missing', () async {
      final result = await repository.getDiaryDetail('missing');

      result.fold(
        (error) => expect(error.code, ApiErrorCode.notFound),
        (_) => fail('Expected Left'),
      );
    });

    test('fetchEntries returns entries ordered by createdAt desc', () async {
      await insertDiary(id: 'old', createdAt: DateTime(2024, 1, 1));
      await insertDiary(id: 'new', createdAt: DateTime(2024, 1, 3));
      await insertDiary(id: 'mid', createdAt: DateTime(2024, 1, 2));

      final result = await repository.fetchDiaries(
        limit: 2,
        cursor: DateTime(2024, 1, 4),
      );

      result.fold((_) => fail('Expected Right'), (entries) {
        expect(entries.map((e) => e.id), ['new', 'mid']);
      });
    });

    test('fetchEntries excludes rows newer than cursor', () async {
      await insertDiary(id: 'old', createdAt: DateTime(2024, 1, 1));
      await insertDiary(id: 'new', createdAt: DateTime(2024, 1, 3));
      await insertDiary(id: 'mid', createdAt: DateTime(2024, 1, 2));

      final result = await repository.fetchDiaries(
        limit: 5,
        cursor: DateTime(2024, 1, 3),
      );

      result.fold((_) => fail('Expected Right'), (entries) {
        expect(entries.map((e) => e.id), ['mid', 'old']);
      });
    });

    test('searchByTitle filters using keyword', () async {
      await insertDiary(
        id: 'sunrise',
        title: 'Morning sun',
        createdAt: DateTime(2024, 1, 1),
      );
      await insertDiary(
        id: 'night',
        title: 'Calm night',
        createdAt: DateTime(2024, 1, 3),
      );
      await insertDiary(
        id: 'sunset',
        title: 'Beautiful Sunset',
        createdAt: DateTime(2024, 1, 2),
      );

      final result = await repository.searchByTitle(
        keyword: 'sun',
        cursor: DateTime(2024, 1, 4),
      );
      result.fold((_) => fail('Expected Right'), (entries) {
        expect(entries.map((e) => e.id), ['sunset', 'sunrise']);
        expect(entries.map((e) => e.id), isNot(contains('night')));
      });
    });

    test('searchByDateRange filters inclusively by date field', () async {
      await insertDiary(
        id: 'jan-01',
        title: 'New Year',
        createdAt: DateTime(2024, 1, 1),
      );
      await insertDiary(
        id: 'jan-10',
        title: 'Mid January',
        createdAt: DateTime(2024, 1, 10),
      );
      await insertDiary(
        id: 'feb-01',
        title: 'February start',
        createdAt: DateTime(2024, 2, 1),
      );

      final result = await repository.searchByDateRange(
        start: DateTime(2024, 1, 5),
        end: DateTime(2024, 2, 1),
        cursor: DateTime(2024, 2, 15),
      );

      result.fold((_) => fail('Expected Right'), (entries) {
        expect(entries.map((e) => e.id), ['feb-01', 'jan-10']);
      });
    });

    test('findAllByDateRange returns rows ordered by date asc', () async {
      await insertDiary(
        id: 'jan-02',
        title: 'Second day',
        createdAt: DateTime(2024, 1, 2),
      );
      await insertDiary(
        id: 'jan-01',
        title: 'First day',
        createdAt: DateTime(2024, 1, 1),
      );
      await insertDiary(
        id: 'feb-01',
        title: 'Next month',
        createdAt: DateTime(2024, 2, 1),
      );

      final result = await repository.findAllByDateRange(
        start: DateTime(2024, 1, 1),
        end: DateTime(2024, 2, 0),
      );

      result.fold((_) => fail('Expected Right'), (entries) {
        expect(entries.map((e) => e.id), ['jan-01', 'jan-02']);
      });
    });
  });

  group('write operations', () {
    test('update returns Right and mutates record', () async {
      await insertDiary(id: 'update-id', title: 'Old', content: 'Old content');

      final result = await repository.update(
        diaryId: 'update-id',
        title: 'New title',
        content: 'New content',
        mood: DiaryMood.none,
      );
      expect(result.isRight(), isTrue);

      final updated = await recordById('update-id');
      expect(updated.title, 'New title');
      expect(updated.content, 'New content');
    });

    test('delete removes row', () async {
      await insertDiary(id: 'delete-me');

      final result = await repository.delete('delete-me');
      expect(result.isRight(), isTrue);

      final rows = await db.select(db.diaryRecords).get();
      expect(rows, isEmpty);
    });
  });

  group('media uploads', () {
    test(
      'uploadMediaFiles returns metadata and saves image dimensions',
      () async {
        final file = await createTempFile(
          'sample.png',
          imageBytes(width: 5, height: 4),
        );

        final result = await repository.uploadMediaFiles(
          diaryId: 'media-meta',
          files: [file],
        );

        expect(result.isRight(), isTrue);
        final medias = result.getOrElse(() => fail('upload failed'));
        expect(medias, hasLength(1));
        final media = medias.first;
        expect(media.width, 5);
        expect(media.height, 4);
        expect(media.sizeInBytes, greaterThan(0));
        expect(media.sortOrder, 0);

        final stored = fileAt(media.relativePath);
        expect(await stored.exists(), isTrue);
      },
    );

    test('create persists medias returned from uploadMediaFiles', () async {
      final file = await createTempFile(
        'entry.png',
        imageBytes(width: 2, height: 2),
      );

      final uploadsEither = await repository.uploadMediaFiles(
        diaryId: 'new-entry',
        files: [file],
      );
      final uploads = uploadsEither.getOrElse(() => fail('upload failed'));

      final result = await repository.create(
        clientId: 'new-entry',
        title: 'entry',
        content: 'body',
        medias: uploads,
      );

      expect(result.isRight(), isTrue);

      final medias = await mediaRecords('new-entry');
      expect(medias, hasLength(1));
      expect(medias.first.relativePath, uploads.first.relativePath);
      expect(medias.first.sortOrder, uploads.first.sortOrder);
    });
  });

  group('watchAll', () {
    test('emits Right data when datasource stream succeeds', () async {
      await insertDiary(
        id: 'stream-1',
        title: 'first',
        createdAt: DateTime(2024, 3, 1),
      );
      await insertDiary(
        id: 'stream-2',
        title: 'second',
        createdAt: DateTime(2024, 4, 1),
      );

      final firstEmission = await repository.watchAll().first;
      firstEmission.fold((_) => fail('Expected Right'), (entries) {
        expect(entries.map((e) => e.id), ['stream-2', 'stream-1']);
      });
    });

    test('emits Left when datasource stream throws', () async {
      final exception = ApiException.cache(message: 'stream failed');
      final repo = DiaryRepositoryImpl(
        _ErrorStreamDiaryDataSource(exception),
        diaryStorage,
      )..setLogger(logger);

      final error = await repo
          .watchAll()
          .firstWhere((either) => either.isLeft())
          .then(
            (either) => either.fold(
              (f) => f,
              (_) => throw StateError('unexpected Right'),
            ),
          );
      expect(error.code, ApiErrorCode.cache);
      expect(error.message, 'stream failed');
    });
  });
}

class _FailingCreateDataSource implements LocalDiaryDbDataSource {
  final ApiException exception;

  _FailingCreateDataSource(this.exception);

  @override
  Future<DiaryRecord> create(CreateDiaryRequestDto dto) =>
      Future.error(exception);

  @override
  Future<void> delete(String id) => throw UnimplementedError();

  @override
  Future<Iterable<DiaryRecord>> fetchRowsByCursor({
    int limit = 20,
    required DateTime cursor,
  }) => throw UnimplementedError();

  @override
  Future<DiaryRecord?> findById(String id) => throw UnimplementedError();

  @override
  Future<Iterable<DiaryRecord>> searchByTitle({
    required String keyword,
    int limit = 20,
    required DateTime cursor,
  }) => throw UnimplementedError();

  @override
  Future<Iterable<DiaryRecord>> searchByContent({
    required String keyword,
    int limit = 20,
    required DateTime cursor,
  }) => throw UnimplementedError();

  @override
  Future<Iterable<DiaryRecord>> searchByDateRange({
    required DateTime start,
    required DateTime end,
    int limit = 20,
    required DateTime cursor,
  }) => throw UnimplementedError();

  @override
  @override
  Future<Iterable<DiaryRecord>> findAllByDateRange({
    required DateTime start,
    required DateTime end,
  }) => throw UnimplementedError();

  @override
  Stream<List<DiaryRecord>> watchAll() => const Stream.empty();

  @override
  Future<DiaryRecord> update(UpdateDiaryRequestDto dto) =>
      throw UnimplementedError();

  @override
  Future<List<DiaryMediaRecord>> fetchMedias(String diaryId) =>
      throw UnimplementedError();

  @override
  Future<DiaryMediaRecord?> findMediaByPath({
    required String diaryId,
    required String relativePath,
  }) => throw UnimplementedError();

  @override
  Future<DiaryMediaRecord> upsertMedia({
    required String diaryId,
    required CreateDiaryMediaRequestDto media,
  }) => throw UnimplementedError();

  @override
  Future<void> deleteMedia({
    required String diaryId,
    required String relativePath,
    bool ignoreMissing = true,
  }) => throw UnimplementedError();

  @override
  Future<void> deleteAllMedias(String diaryId) => throw UnimplementedError();
}

class _ErrorStreamDiaryDataSource implements LocalDiaryDbDataSource {
  final ApiException exception;

  _ErrorStreamDiaryDataSource(this.exception);

  @override
  Future<DiaryRecord> create(CreateDiaryRequestDto dto) =>
      throw UnimplementedError();

  @override
  Future<void> delete(String id) => throw UnimplementedError();

  @override
  Future<Iterable<DiaryRecord>> fetchRowsByCursor({
    int limit = 20,
    required DateTime cursor,
  }) => throw UnimplementedError();

  @override
  Future<DiaryRecord?> findById(String id) => throw UnimplementedError();

  @override
  Future<Iterable<DiaryRecord>> searchByTitle({
    required String keyword,
    int limit = 20,
    required DateTime cursor,
  }) => throw UnimplementedError();

  @override
  Future<Iterable<DiaryRecord>> searchByContent({
    required String keyword,
    int limit = 20,
    required DateTime cursor,
  }) => throw UnimplementedError();

  @override
  Future<Iterable<DiaryRecord>> searchByDateRange({
    required DateTime start,
    required DateTime end,
    int limit = 20,
    required DateTime cursor,
  }) => throw UnimplementedError();

  @override
  @override
  Future<Iterable<DiaryRecord>> findAllByDateRange({
    required DateTime start,
    required DateTime end,
  }) => throw UnimplementedError();

  @override
  Stream<List<DiaryRecord>> watchAll() =>
      Stream<List<DiaryRecord>>.error(exception, StackTrace.current);

  @override
  Future<DiaryRecord> update(UpdateDiaryRequestDto dto) =>
      throw UnimplementedError();

  @override
  Future<List<DiaryMediaRecord>> fetchMedias(String diaryId) =>
      throw UnimplementedError();

  @override
  Future<DiaryMediaRecord?> findMediaByPath({
    required String diaryId,
    required String relativePath,
  }) => throw UnimplementedError();

  @override
  Future<DiaryMediaRecord> upsertMedia({
    required String diaryId,
    required CreateDiaryMediaRequestDto media,
  }) => throw UnimplementedError();

  @override
  Future<void> deleteMedia({
    required String diaryId,
    required String relativePath,
    bool ignoreMissing = true,
  }) => throw UnimplementedError();

  @override
  Future<void> deleteAllMedias(String diaryId) => throw UnimplementedError();
}
