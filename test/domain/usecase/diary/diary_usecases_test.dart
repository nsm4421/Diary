import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:diary/core/error/error_code.dart';
import 'package:diary/core/error/failure.dart';
import 'package:diary/domain/entity/diary_entry.dart';
import 'package:diary/domain/repository/diary_repository.dart';
import 'package:diary/domain/usecase/diary/diary_usecases.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late StubDiaryRepository repository;
  late DiaryUseCases useCases;

  setUp(() {
    repository = StubDiaryRepository();
    useCases = DiaryUseCases(repository);
  });

  group('create', () {
    test('returns validation failure when content is empty', () async {
      final result = await useCases.create(content: '   ');

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure.code, ErrorCode.validation);
        expect(failure.message, '일기 내용을 입력해주세요.');
      }, (_) => fail('Expected Left'));
    });

    test('returns validation failure when content exceeds limit', () async {
      final longContent = 'a' * (kDiaryEntryMaxContentLength + 1);

      final result = await useCases.create(content: longContent);

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure.code, ErrorCode.validation);
        expect(
          failure.message,
          '일기 내용은 최대 $kDiaryEntryMaxContentLength자까지 작성할 수 있습니다.',
        );
      }, (_) => fail('Expected Left'));
    });

    test('returns validation failure when title exceeds limit', () async {
      final longTitle = 'a' * (kDiaryEntryMaxTitleLength + 1);
      final result = await useCases.create(
        title: longTitle,
        content: 'content',
      );

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure.code, ErrorCode.validation);
        expect(
          failure.message,
          '제목은 최대 $kDiaryEntryMaxTitleLength자까지 입력할 수 있습니다.',
        );
      }, (_) => fail('Expected Left'));
    });

    test('normalizes inputs before delegating to repository', () async {
      String? receivedClientId;
      String? receivedTitle;
      String? receivedContent;

      repository.createHandler =
          ({String? clientId, String? title, required String content}) async {
            receivedClientId = clientId;
            receivedTitle = title;
            receivedContent = content;
            return Right(_fakeEntry(id: 'created'));
          };

      final result = await useCases.create(
        clientId: ' client ',
        title: ' title ',
        content: ' body ',
      );

      expect(result.isRight(), isTrue);
      expect(receivedClientId, 'client');
      expect(receivedTitle, 'title');
      expect(receivedContent, ' body'); // right trim
    });

    test('maps failure message based on error code', () async {
      repository.createHandler =
          ({String? clientId, String? title, required String content}) async {
            return Left(
              Failure(code: ErrorCode.network, message: 'raw message'),
            );
          };

      final result = await useCases.create(content: 'body');

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure.code, ErrorCode.network);
        expect(failure.message, '네트워크 연결을 확인해주세요.');
      }, (_) => fail('Expected Left'));
    });
  });

  group('update', () {
    test('returns validation failure when id is blank', () async {
      final result = await useCases.update(id: '   ', content: 'content');

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure.code, ErrorCode.validation);
        expect(failure.message, '일기 식별자가 올바르지 않습니다.');
      }, (_) => fail('Expected Left'));
    });

    test('returns validation failure when content exceeds limit', () async {
      final result = await useCases.update(
        id: 'id',
        content: 'a' * (kDiaryEntryMaxContentLength + 1),
      );

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure.code, ErrorCode.validation);
        expect(
          failure.message,
          '일기 내용은 최대 $kDiaryEntryMaxContentLength자까지 작성할 수 있습니다.',
        );
      }, (_) => fail('Expected Left'));
    });

    test('maps repository failures to friendly messages', () async {
      repository.updateHandler =
          ({required String id, String? title, required String content}) async {
            expect(id, 'id');
            return Left(
              Failure(code: ErrorCode.server, message: 'server message'),
            );
          };

      final result = await useCases.update(id: ' id ', content: 'content');

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure.code, ErrorCode.server);
        expect(failure.message, '서버에서 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
      }, (_) => fail('Expected Left'));
    });
  });

  group('get', () {
    test('returns validation failure when id is blank', () async {
      final result = await useCases.get('  ');

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure.code, ErrorCode.validation);
        expect(failure.message, '일기 식별자가 올바르지 않습니다.');
      }, (_) => fail('Expected Left'));
    });

    test('maps repository failure message', () async {
      repository.findByIdHandler = (id) async {
        expect(id, 'id');
        return Left(Failure(code: ErrorCode.notFound, message: 'not found'));
      };

      final result = await useCases.get(' id ');

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure.code, ErrorCode.notFound);
        expect(failure.message, '요청한 데이터를 찾을 수 없습니다.');
      }, (_) => fail('Expected Left'));
    });
  });

  group('fetch', () {
    test('returns validation failure when limit is invalid', () async {
      final result = await useCases.fetch(
        param: FetchDiaryParam.none(),
        cursor: DateTime(2024, 1, 1),
        limit: 0,
      );

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure.code, ErrorCode.validation);
        expect(failure.message, '조회 개수는 1 이상이어야 합니다.');
      }, (_) => fail('Expected Left'));
    });

    test('maps repository failure message for default fetch', () async {
      repository.fetchEntriesHandler =
          ({int limit = 20, required DateTime cursor}) async {
            expect(limit, 10);
            expect(cursor, DateTime(2024, 1, 4));
            return Left(Failure(code: ErrorCode.cache, message: 'cache issue'));
          };

      final result = await useCases.fetch(
        cursor: DateTime(2024, 1, 4),
        limit: 10,
        param: FetchDiaryParam.none(),
      );

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure.code, ErrorCode.cache);
        expect(failure.message, '저장된 데이터를 불러오는 중 문제가 발생했습니다.');
      }, (_) => fail('Expected Left'));
    });

    test('returns pageable result with next cursor when data exists', () async {
      final entries = [
        _fakeEntry(id: 'a', createdAt: DateTime(2024, 1, 3).toUtc()),
        _fakeEntry(id: 'b', createdAt: DateTime(2024, 1, 2).toUtc()),
      ];

      repository.fetchEntriesHandler =
          ({int limit = 20, required DateTime cursor}) async {
            expect(cursor, DateTime(2024, 1, 4));
            return Right(entries);
          };

      final result = await useCases.fetch(
        cursor: DateTime(2024, 1, 4),
        limit: 2,
        param: FetchDiaryParam.none(),
      );

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected Right'), (pageable) {
        expect(pageable.items.map((e) => e.id), ['a', 'b']);
        expect(pageable.nextCursor, DateTime(2024, 1, 2).toUtc().toString());
      });
    });

    test('maps repository failure message for title search', () async {
      repository.searchByTitleHandler =
          ({
            required String keyword,
            int limit = 20,
            required DateTime cursor,
          }) async {
            expect(keyword, 'keyword');
            expect(cursor, DateTime(2024, 2, 1));
            return Left(Failure(code: ErrorCode.database, message: 'db issue'));
          };

      final result = await useCases.fetch(
        cursor: DateTime(2024, 2, 1),
        limit: 15,
        param: FetchDiaryParam.title('keyword'),
      );

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure.code, ErrorCode.database);
        expect(failure.message, '저장된 데이터를 불러오는 중 문제가 발생했습니다.');
      }, (_) => fail('Expected Left'));
    });
  });

  group('delete', () {
    test('returns validation failure when id is blank', () async {
      final result = await useCases.delete('  ');

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure.code, ErrorCode.validation);
        expect(failure.message, '일기 식별자가 올바르지 않습니다.');
      }, (_) => fail('Expected Left'));
    });

    test('maps repository failure message', () async {
      repository.deleteHandler = (id) async {
        expect(id, 'id');
        return Left(Failure(code: ErrorCode.storage, message: 'storage issue'));
      };

      final result = await useCases.delete(' id ');

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure.code, ErrorCode.storage);
        expect(failure.message, '저장된 데이터를 불러오는 중 문제가 발생했습니다.');
      }, (_) => fail('Expected Left'));
    });
  });

  group('watch', () {
    test('maps failure emitted by repository', () async {
      repository.watchAllHandler = () {
        return Stream.value(
          Left(Failure(code: ErrorCode.timeout, message: 'timeout')),
        );
      };

      final either = await useCases.watch().first;
      expect(either.isLeft(), isTrue);
      either.fold((failure) {
        expect(failure.code, ErrorCode.timeout);
        expect(failure.message, '요청 시간이 초과되었습니다. 잠시 후 다시 시도해주세요.');
      }, (_) => fail('Expected Left'));
    });
  });
}

DiaryEntry _fakeEntry({
  required String id,
  String? title,
  String content = 'content',
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final created = createdAt ?? DateTime.now().toUtc();
  final updated = updatedAt ?? created;
  return DiaryEntry(
    id: id,
    title: title,
    content: content,
    isTemp: false,
    createdAt: created,
    updatedAt: updated,
    date: '2024-01-01',
  );
}

class StubDiaryRepository implements DiaryRepository {
  Future<Either<Failure, DiaryEntry>> Function({
    String? clientId,
    String? title,
    required String content,
  })?
  createHandler;

  Future<Either<Failure, DiaryEntry?>> Function(String id)? findByIdHandler;

  Future<Either<Failure, List<DiaryEntry>>> Function({
    int limit,
    required DateTime cursor,
  })?
  fetchEntriesHandler;

  Future<Either<Failure, List<DiaryEntry>>> Function({
    required String keyword,
    int limit,
    required DateTime cursor,
  })?
  searchByTitleHandler;

  Stream<Either<Failure, List<DiaryEntry>>> Function()? watchAllHandler;

  Future<Either<Failure, DiaryEntry>> Function({
    required String id,
    String? title,
    required String content,
  })?
  updateHandler;

  Future<Either<Failure, void>> Function(String id)? deleteHandler;

  @override
  Future<Either<Failure, DiaryEntry>> create({
    String? clientId,
    String? title,
    required String content,
  }) {
    final handler = createHandler;
    if (handler == null) {
      throw StateError('createHandler not set');
    }
    return handler(clientId: clientId, title: title, content: content);
  }

  @override
  Future<Either<Failure, DiaryEntry?>> findById(String id) {
    final handler = findByIdHandler;
    if (handler == null) {
      throw StateError('findByIdHandler not set');
    }
    return handler(id);
  }

  @override
  Future<Either<Failure, List<DiaryEntry>>> fetchEntries({
    int limit = 20,
    required DateTime cursor,
  }) {
    final handler = fetchEntriesHandler;
    if (handler == null) {
      throw StateError('fetchEntriesHandler not set');
    }
    return handler(limit: limit, cursor: cursor);
  }

  @override
  Future<Either<Failure, List<DiaryEntry>>> searchByTitle({
    required String keyword,
    int limit = 20,
    required DateTime cursor,
  }) {
    final handler = searchByTitleHandler;
    if (handler == null) {
      throw StateError('searchByTitleHandler not set');
    }
    return handler(keyword: keyword, limit: limit, cursor: cursor);
  }

  @override
  Stream<Either<Failure, List<DiaryEntry>>> watchAll() {
    final handler = watchAllHandler;
    if (handler == null) {
      throw StateError('watchAllHandler not set');
    }
    return handler();
  }

  @override
  Future<Either<Failure, DiaryEntry>> update({
    required String id,
    String? title,
    required String content,
  }) {
    final handler = updateHandler;
    if (handler == null) {
      throw StateError('updateHandler not set');
    }
    return handler(id: id, title: title, content: content);
  }

  @override
  Future<Either<Failure, void>> delete(String id) {
    final handler = deleteHandler;
    if (handler == null) {
      throw StateError('deleteHandler not set');
    }
    return handler(id);
  }
}
