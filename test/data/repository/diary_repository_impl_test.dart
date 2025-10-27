import 'package:dartz/dartz.dart';
import 'package:diary/core/error/app_exception.dart';
import 'package:diary/core/error/error_code.dart';
import 'package:diary/core/error/failure.dart';
import 'package:diary/data/datasoure/local/database/local_database.dart';
import 'package:diary/data/datasoure/local/database/local_database_dao.dart';
import 'package:diary/data/datasoure/local/diary/dto.dart';
import 'package:diary/data/datasoure/local/diary/local_diary_datasource.dart';
import 'package:diary/data/repository/diary_repository_impl.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LocalDatabase db;
  late LocalDatabaseDao dao;
  late LocalDiaryDataSource dataSource;
  late DiaryRepositoryImpl repository;

  setUp(() {
    db = LocalDatabase.test();
    dao = LocalDatabaseDao(db);
    dataSource = LocalDiaryDataSourceImpl(dao);
    repository = DiaryRepositoryImpl(dataSource);
  });

  tearDown(() async {
    await db.close();
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

    test('fetchEntries returns ordered entries', () async {
      await insertDiary(id: 'old', createdAt: DateTime(2024, 1, 1));
      await insertDiary(id: 'new', createdAt: DateTime(2024, 1, 3));
      await insertDiary(id: 'mid', createdAt: DateTime(2024, 1, 2));

      final result = await repository.fetchEntries(limit: 2, offset: 0);
      result.fold((_) => fail('Expected Right'), (entries) {
        expect(entries.map((e) => e.id), ['new', 'mid']);
      });
    });

    test('searchByTitle filters using keyword', () async {
      await insertDiary(id: 'sunrise', title: 'Morning sun');
      await insertDiary(id: 'night', title: 'Calm night');
      await insertDiary(id: 'sunset', title: 'Beautiful Sunset');

      final result = await repository.searchByTitle(keyword: 'sun');
      result.fold((_) => fail('Expected Right'), (entries) {
        expect(entries.map((e) => e.id), containsAll(['sunrise', 'sunset']));
        expect(entries.map((e) => e.id), isNot(contains('night')));
      });
    });
  });

  group('write operations', () {
    test('update returns Right and mutates record', () async {
      await insertDiary(id: 'update-id', title: 'Old', content: 'Old content');

      final result = await repository.update(
        id: 'update-id',
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
      final repo = DiaryRepositoryImpl(_ErrorStreamDiaryDataSource(exception));

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
  Future<List<DiaryRecord>> fetchRows({int limit = 20, int offset = 0}) =>
      throw UnimplementedError();

  @override
  Future<DiaryRecord?> findById(String id) => throw UnimplementedError();

  @override
  Future<List<DiaryRecord>> searchByTitle({
    required String keyword,
    int limit = 20,
    int offset = 0,
  }) => throw UnimplementedError();

  @override
  Stream<List<DiaryRecord>> watchAll() => const Stream.empty();

  @override
  Future<DiaryRecord> update(UpdateDiaryRequestDto dto) =>
      throw UnimplementedError();
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
  Future<List<DiaryRecord>> fetchRows({int limit = 20, int offset = 0}) =>
      throw UnimplementedError();

  @override
  Future<DiaryRecord?> findById(String id) => throw UnimplementedError();

  @override
  Future<List<DiaryRecord>> searchByTitle({
    required String keyword,
    int limit = 20,
    int offset = 0,
  }) => throw UnimplementedError();

  @override
  Stream<List<DiaryRecord>> watchAll() =>
      Stream<List<DiaryRecord>>.error(exception, StackTrace.current);

  @override
  Future<DiaryRecord> update(UpdateDiaryRequestDto dto) =>
      throw UnimplementedError();
}
