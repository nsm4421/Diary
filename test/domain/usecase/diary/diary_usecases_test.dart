import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:diary/core/error/api/api_error.dart';
import 'package:diary/core/error/constant/error_code.dart';
import 'package:diary/core/value_objects/constraint.dart';
import 'package:diary/core/value_objects/diary.dart';
import 'package:diary/domain/entity/diary_detail_entity.dart';
import 'package:diary/domain/entity/diary_entity.dart';
import 'package:diary/domain/repository/diary_repository.dart';
import 'package:diary/domain/usecase/diary/diary_usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  late StubDiaryRepository repository;
  late DiaryUseCases useCases;

  setUp(() {
    repository = StubDiaryRepository();
    useCases = DiaryUseCases(repository);
  });

  Future<File> createTempImage(String name) async {
    final dir = await Directory.systemTemp.createTemp('create_usecase');
    addTearDown(() => dir.delete(recursive: true));
    final file = File(p.join(dir.path, name));
    await file.create(recursive: true);
    await file.writeAsBytes([1, 2, 3, 4], flush: true);
    return file;
  }

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
          ({
            String? clientId,
            String? title,
            required String content,
            List<CreateDiaryMediaRequest> medias = const [],
          }) async {
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
          ({
            String? clientId,
            String? title,
            required String content,
            List<CreateDiaryMediaRequest> medias = const [],
          }) async {
            return Left(
              const ApiError(
                code: ApiErrorCode.network,
                message: 'raw message',
              ),
            );
          };

      final result = await useCases.create(content: 'body');

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure.code, ErrorCode.network);
        expect(failure.message, '네트워크 연결을 확인해주세요.');
      }, (_) => fail('Expected Left'));
    });

    test('uploads media files before creating diary entry', () async {
      final file = await createTempImage('image.jpg');

      repository.uploadMediaFilesHandler =
          ({required String diaryId, required List<File> files}) async {
            expect(diaryId.trim(), isNotEmpty);
            expect(files, hasLength(1));
            expect(files.first.path, file.path);
            return Right([
              const CreateDiaryMediaRequest(
                relativePath: 'diary/test/0000_image.jpg',
                fileName: 'image.jpg',
                mimeType: 'image/jpeg',
                sizeInBytes: 4,
                width: 100,
                height: 80,
                sortOrder: 0,
              ),
            ]);
          };

      repository.createHandler =
          ({
            String? clientId,
            String? title,
            required String content,
            List<CreateDiaryMediaRequest> medias = const [],
          }) async {
            expect(clientId, 'client');
            expect(title, 'title');
            expect(content, ' body');
            expect(medias, hasLength(1));
            expect(medias.first.relativePath, 'diary/test/0000_image.jpg');
            return Right(_fakeEntry(id: clientId!));
          };

      final result = await useCases.create(
        clientId: ' client ',
        title: ' title ',
        content: ' body ',
        files: [file],
      );

      expect(result.isRight(), isTrue);
    });

    test('propagates failure when uploadMediaFiles fails', () async {
      final file = await createTempImage('image.jpg');

      bool createCalled = false;

      repository.uploadMediaFilesHandler =
          ({required String diaryId, required List<File> files}) async {
            return Left(
              const ApiError(
                code: ApiErrorCode.storage,
                message: 'upload failed',
              ),
            );
          };

      repository.createHandler =
          ({
            String? clientId,
            String? title,
            required String content,
            List<CreateDiaryMediaRequest> medias = const [],
          }) async {
            createCalled = true;
            return Right(_fakeEntry(id: clientId ?? 'id'));
          };

      final result = await useCases.create(
        clientId: 'client',
        content: 'body',
        files: [file],
      );

      expect(result.isLeft(), isTrue);
      expect(createCalled, isFalse);
      result.fold((failure) {
        expect(failure.code, ErrorCode.storage);
        expect(failure.message, '파일을 처리하는 중 문제가 발생했습니다.');
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
          ({
            required String diaryId,
            String? title,
            required String content,
            List<CreateDiaryMediaRequest> medias = const [],
          }) async {
            expect(diaryId, 'id');
            return Left(
              const ApiError(
                code: ApiErrorCode.server,
                message: 'server message',
              ),
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
      final result = await useCases.getDetail('  ');

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure.code, ErrorCode.validation);
        expect(failure.message, '일기 식별자가 올바르지 않습니다.');
      }, (_) => fail('Expected Left'));
    });

    test('maps repository failure message', () async {
      repository.getDiaryDetailHandler = (id) async {
        expect(id, 'id');
        return Left(
          const ApiError(
            code: ApiErrorCode.notFound,
            message: 'not found',
          ),
        );
      };

      final result = await useCases.getDetail(' id ');

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
            return Left(
              const ApiError(
                code: ApiErrorCode.cache,
                message: 'cache issue',
              ),
            );
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
        expect(pageable.nextCursor, DateTime(2024, 1, 2).toUtc());
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
            return Left(
              const ApiError(
                code: ApiErrorCode.database,
                message: 'db issue',
              ),
            );
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

    test('maps repository failure message for date range search', () async {
      repository.searchByDateRangeHandler =
          ({
            required DateTime start,
            required DateTime end,
            int limit = 20,
            required DateTime cursor,
          }) async {
            expect(start, DateTime(2024, 3, 1));
            expect(end, DateTime(2024, 3, 31));
            expect(cursor, DateTime(2024, 4, 1));
            return Left(
              const ApiError(
                code: ApiErrorCode.cache,
                message: 'range issue',
              ),
            );
          };

      final result = await useCases.fetch(
        cursor: DateTime(2024, 4, 1),
        limit: 5,
        param: FetchDiaryParam.dateRange(
          start: DateTime(2024, 3, 1),
          end: DateTime(2024, 3, 31),
        ),
      );

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure.code, ErrorCode.cache);
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
        return Left(
          const ApiError(
            code: ApiErrorCode.storage,
            message: 'storage issue',
          ),
        );
      };

      final result = await useCases.delete(' id ');

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure.code, ErrorCode.storage);
        expect(failure.message, '파일을 처리하는 중 문제가 발생했습니다.');
      }, (_) => fail('Expected Left'));
    });
  });

  group('watch', () {
    test('maps failure emitted by repository', () async {
      repository.watchAllHandler = () {
        return Stream.value(
          Left(
            const ApiError(
              code: ApiErrorCode.timeout,
              message: 'timeout',
            ),
          ),
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

DiaryEntity _fakeEntry({
  required String id,
  String? title,
  String content = 'content',
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final created = createdAt ?? DateTime.now().toUtc();
  final updated = updatedAt ?? created;
  return DiaryEntity(
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
  Future<Either<ApiError, DiaryEntity>> Function({
    String? clientId,
    String? title,
    required String content,
    List<CreateDiaryMediaRequest> medias,
  })?
  createHandler;

  Future<Either<ApiError, DiaryEntity?>> Function(String id)? findByIdHandler;

  Future<Either<ApiError, DiaryDetailEntity?>> Function(String id)?
  getDiaryDetailHandler;

  Future<Either<ApiError, List<DiaryEntity>>> Function({
    int limit,
    required DateTime cursor,
  })?
  fetchEntriesHandler;

  Future<Either<ApiError, List<DiaryEntity>>> Function({
    required String keyword,
    int limit,
    required DateTime cursor,
  })?
  searchByTitleHandler;
  Future<Either<ApiError, List<DiaryEntity>>> Function({
    required DateTime start,
    required DateTime end,
    int limit,
    required DateTime cursor,
  })?
  searchByDateRangeHandler;
  Future<Either<ApiError, List<DiaryEntity>>> Function({
    required String keyword,
    int limit,
    required DateTime cursor,
  })?
  searchByContentHandler;

  Stream<Either<ApiError, List<DiaryEntity>>> Function()? watchAllHandler;

  Future<Either<ApiError, DiaryEntity>> Function({
    required String diaryId,
    String? title,
    required String content,
    List<CreateDiaryMediaRequest> medias,
  })?
  updateHandler;

  Future<Either<ApiError, List<CreateDiaryMediaRequest>>> Function({
    required String diaryId,
    required List<File> files,
  })
  uploadMediaFilesHandler =
      ({required String diaryId, required List<File> files}) async {
        return const Right([]);
      };

  Future<Either<ApiError, void>> Function(String diaryId)? deleteHandler;

  @override
  Future<Either<ApiError, DiaryEntity>> create({
    String? clientId,
    String? title,
    required String content,
    List<CreateDiaryMediaRequest> medias = const [],
  }) {
    final handler = createHandler;
    if (handler == null) {
      throw StateError('createHandler not set');
    }
    return handler(
      clientId: clientId,
      title: title,
      content: content,
      medias: medias,
    );
  }

  @override
  Future<Either<ApiError, DiaryEntity?>> findById(String diaryId) {
    final handler = findByIdHandler;
    if (handler == null) {
      throw StateError('findByIdHandler not set');
    }
    return handler(diaryId);
  }

  @override
  Future<Either<ApiError, DiaryDetailEntity?>> getDiaryDetail(String diaryId) {
    final handler = getDiaryDetailHandler;
    if (handler == null) {
      throw StateError('getDiaryDetailHandler not set');
    }
    return handler(diaryId);
  }

  @override
  Future<Either<ApiError, List<DiaryEntity>>> fetchDiaries({
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
  Future<Either<ApiError, List<DiaryEntity>>> searchByTitle({
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
  Future<Either<ApiError, List<DiaryEntity>>> searchByContent({
    required String keyword,
    int limit = 20,
    required DateTime cursor,
  }) {
    final handler = searchByContentHandler;
    if (handler == null) {
      throw StateError('searchByContentHandler not set');
    }
    return handler(keyword: keyword, limit: limit, cursor: cursor);
  }

  @override
  Future<Either<ApiError, List<DiaryEntity>>> searchByDateRange({
    required DateTime start,
    required DateTime end,
    int limit = 20,
    required DateTime cursor,
  }) {
    final handler = searchByDateRangeHandler;
    if (handler == null) {
      throw StateError('searchByDateRangeHandler not set');
    }
    return handler(start: start, end: end, limit: limit, cursor: cursor);
  }

  @override
  Stream<Either<ApiError, List<DiaryEntity>>> watchAll() {
    final handler = watchAllHandler;
    if (handler == null) {
      throw StateError('watchAllHandler not set');
    }
    return handler();
  }

  @override
  Future<Either<ApiError, DiaryEntity>> update({
    required String diaryId,
    String? title,
    required String content,
    List<CreateDiaryMediaRequest> medias = const [],
  }) {
    final handler = updateHandler;
    if (handler == null) {
      throw StateError('updateHandler not set');
    }
    return handler(
      diaryId: diaryId,
      title: title,
      content: content,
      medias: medias,
    );
  }

  @override
  Future<Either<ApiError, void>> delete(String diaryId) {
    final handler = deleteHandler;
    if (handler == null) {
      throw StateError('deleteHandler not set');
    }
    return handler(diaryId);
  }

  @override
  Future<Either<ApiError, List<CreateDiaryMediaRequest>>> uploadMediaFiles({
    required String diaryId,
    required List<File> files,
  }) {
    return uploadMediaFilesHandler(diaryId: diaryId, files: files);
  }
}
