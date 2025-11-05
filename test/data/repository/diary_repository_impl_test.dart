import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:diary/core/error/app_exception.dart';
import 'package:diary/core/error/error_code.dart';
import 'package:diary/core/error/failure.dart';
import 'package:diary/data/datasoure/local/database/local_database.dart';
import 'package:diary/data/datasoure/local/database/local_database_dao.dart';
import 'package:diary/data/datasoure/local/diary/dto.dart';
import 'package:diary/data/datasoure/local/diary/local_diary_datasource.dart';
import 'package:diary/data/datasoure/local/diary/local_diary_storage.dart';
import 'package:diary/data/datasoure/local/storage/local_storage_datasource.dart';
import 'package:diary/data/repository/diary_repository_impl.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:image/image.dart' as img;

void main() {
  late LocalDatabase db;
  late LocalDatabaseDao dao;
  late Logger logger;
  late LocalDiaryDataSource diaryDataSource;
  late LocalStorageDataSource storageDataSource;
  late LocalDiaryStorage diaryStorage;
  late DiaryRepositoryImpl repository;
  late Directory storageRoot;
  late Directory inputDir;

  setUp(() async {
    db = LocalDatabase.test();
    dao = LocalDatabaseDao(db);
    logger = Logger(
      level: Level.nothing,
      printer: SimplePrinter(printTime: false),
    );
    diaryDataSource = LocalDiaryDataSourceImpl(dao, logger);
    storageRoot = await Directory.systemTemp.createTemp('diary_repo_test');
    storageDataSource = LocalStorageDataSourceImpl(
      baseDirectory: storageRoot,
      logger: logger,
    );
    diaryStorage = LocalDiaryStorageImpl(storageDataSource);
    repository = DiaryRepositoryImpl(diaryDataSource, diaryStorage);
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
            date: Value(created.toIso8601String()),
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

  Failure expectLeft<E>(Either<Failure, E> either) {
    return either.fold(
      (failure) => failure,
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

    test('returns Failure when datasource throws AppException', () async {
      final failingRepo = DiaryRepositoryImpl(
        _FailingCreateDataSource(AppException.cache(message: 'failed')),
        diaryStorage,
      );

      final result = await failingRepo.create(content: 'body');
      final failure = expectLeft(result);
      expect(failure.code, ErrorCode.cache);
      expect(failure.message, 'failed');
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

    test('getDiaryDetail returns Right(null) when record missing', () async {
      final result = await repository.getDiaryDetail('missing');

      result.fold((_) => fail('Expected Right'), (entry) {
        expect(entry, isNull);
      });
    });

    test('fetchEntries returns entries ordered by createdAt desc', () async {
      await insertDiary(id: 'old', createdAt: DateTime(2024, 1, 1));
      await insertDiary(id: 'new', createdAt: DateTime(2024, 1, 3));
      await insertDiary(id: 'mid', createdAt: DateTime(2024, 1, 2));

      final result = await repository.fetchEntries(
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

      final result = await repository.fetchEntries(
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
  });

  group('write operations', () {
    test('update returns Right and mutates record', () async {
      await insertDiary(id: 'update-id', title: 'Old', content: 'Old content');

      final result = await repository.update(
        diaryId: 'update-id',
        title: 'New title',
        content: 'New content',
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
      final exception = AppException.cache(message: 'stream failed');
      final repo = DiaryRepositoryImpl(
        _ErrorStreamDiaryDataSource(exception),
        diaryStorage,
      );

      final failure = await repo
          .watchAll()
          .firstWhere((either) => either.isLeft())
          .then(
            (either) => either.fold(
              (f) => f,
              (_) => throw StateError('unexpected Right'),
            ),
          );
      expect(failure.code, ErrorCode.cache);
      expect(failure.message, 'stream failed');
    });
  });
}

class _FailingCreateDataSource implements LocalDiaryDataSource {
  final AppException exception;

  _FailingCreateDataSource(this.exception);

  @override
  Future<DiaryRecord> create(CreateDiaryRequestDto dto) =>
      Future.error(exception);

  @override
  Future<void> delete(String id) => throw UnimplementedError();

  @override
  Future<List<DiaryRecord>> fetchRowsByCursor({
    int limit = 20,
    required DateTime cursor,
  }) => throw UnimplementedError();

  @override
  Future<DiaryRecord?> findById(String id) => throw UnimplementedError();

  @override
  Future<List<DiaryRecord>> searchByTitle({
    required String keyword,
    int limit = 20,
    required DateTime cursor,
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

class _ErrorStreamDiaryDataSource implements LocalDiaryDataSource {
  final AppException exception;

  _ErrorStreamDiaryDataSource(this.exception);

  @override
  Future<DiaryRecord> create(CreateDiaryRequestDto dto) =>
      throw UnimplementedError();

  @override
  Future<void> delete(String id) => throw UnimplementedError();

  @override
  Future<List<DiaryRecord>> fetchRowsByCursor({
    int limit = 20,
    required DateTime cursor,
  }) => throw UnimplementedError();

  @override
  Future<DiaryRecord?> findById(String id) => throw UnimplementedError();

  @override
  Future<List<DiaryRecord>> searchByTitle({
    required String keyword,
    int limit = 20,
    required DateTime cursor,
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
