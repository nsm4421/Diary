import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:diary/core/error/api/api_error.dart';
import 'package:diary/domain/entity/diary_detail_entity.dart';
import 'package:diary/domain/entity/diary_entity.dart';
import 'package:diary/domain/repository/diary_repository.dart';
import 'package:diary/domain/usecase/diary/diary_usecases.dart';
import 'package:diary/presentation/provider/diary/create/create_diary_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  late StubDiaryRepository repository;
  late CreateDiaryCubit cubit;
  late Directory tempDir;

  setUp(() async {
    repository = StubDiaryRepository();
    cubit = CreateDiaryCubit(DiaryUseCases(repository));
    tempDir = await Directory.systemTemp.createTemp('create_cubit_test');
  });

  tearDown(() async {
    await cubit.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  File tempImage(String name) {
    final file = File(p.join(tempDir.path, name));
    file.createSync(recursive: true);
    file.writeAsBytesSync([1, 2, 3, 4], flush: true);
    return file;
  }

  test('addMediaFiles enforces maximum of three images', () {
    cubit.addMediaFiles([tempImage('a.png')]);
    expect(cubit.state.medias.length, 1);

    cubit.addMediaFiles([tempImage('b.png'), tempImage('c.png')]);
    expect(cubit.state.medias.length, 3);

    cubit.addMediaFiles([tempImage('d.png'), tempImage('e.png')]);
    expect(cubit.state.medias.length, 3);
  });

  test('removeMediaAt removes the target image', () {
    final files = [tempImage('a.png'), tempImage('b.png'), tempImage('c.png')];
    cubit.addMediaFiles(files);
    cubit.removeMediaAt(1);

    expect(cubit.state.medias.length, 2);
    expect(cubit.state.medias.map((f) => p.basename(f.path)), [
      'a.png',
      'c.png',
    ]);
  });

  test('handleSubmit uploads media files and emits success', () async {
    final files = [tempImage('a.png'), tempImage('b.png')];

    repository.uploadMediaFilesHandler =
        ({required String diaryId, required List<File> files}) async {
          expect(diaryId, isNotEmpty);
          expect(files.length, 2);
          return Right(
            List.generate(files.length, (index) {
              return CreateDiaryMediaRequest(
                relativePath: 'diary/$diaryId/000$index-file.png',
                fileName: 'file_$index.png',
                mimeType: 'image/png',
                sizeInBytes: 4,
                width: 100,
                height: 80,
                sortOrder: index,
              );
            }),
          );
        };

    repository.createHandler =
        ({
          String? clientId,
          String? title,
          required String content,
          List<CreateDiaryMediaRequest> medias = const [],
        }) async {
          expect(clientId, isNotEmpty);
          expect(title, 'title');
          expect(content, ' content');
          expect(medias.length, 2);
          return Right(
            DiaryEntity(
              id: clientId!,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              date: '2024-01-01',
              content: content,
            ),
          );
        };

    cubit.handleChange(title: ' title ', content: ' content ');
    cubit.addMediaFiles(files);

    await cubit.handleSubmit();
    await Future.delayed(const Duration(milliseconds: 1100));

    expect(cubit.state.isSuccess, isTrue);
  });

  test('handleSubmit surfaces failure when uploadMediaFiles fails', () async {
    final file = tempImage('a.png');
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
          return Right(
            DiaryEntity(
              id: clientId ?? 'id',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              date: '2024-01-01',
              content: content,
            ),
          );
        };

    cubit.handleChange(content: 'body');
    cubit.addMediaFiles([file]);

    await cubit.handleSubmit();

    expect(cubit.state.isError, isTrue);
    expect(cubit.state.errorMessage, isNotEmpty);
    expect(createCalled, isFalse);
  });
}

class StubDiaryRepository implements DiaryRepository {
  Future<Either<ApiError, DiaryEntity>> Function({
    String? clientId,
    String? title,
    required String content,
    List<CreateDiaryMediaRequest> medias,
  })?
  createHandler;

  Future<Either<ApiError, DiaryEntity?>> Function(String diaryId)?
  findByIdHandler;

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
  Future<Either<ApiError, DiaryEntity?>> findById(String diaryId) =>
      throw UnimplementedError();

  @override
  Future<Either<ApiError, DiaryDetailEntity?>> getDiaryDetail(String diaryId) =>
      throw UnimplementedError();

  @override
  Future<Either<ApiError, List<DiaryEntity>>> fetchDiaries({
    int limit = 20,
    required DateTime cursor,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, List<DiaryEntity>>> searchByTitle({
    required String keyword,
    int limit = 20,
    required DateTime cursor,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, List<DiaryEntity>>> searchByContent({
    required String keyword,
    int limit = 20,
    required DateTime cursor,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, List<DiaryEntity>>> searchByDateRange({
    required DateTime start,
    required DateTime end,
    int limit = 20,
    required DateTime cursor,
  }) => throw UnimplementedError();

  @override
  Stream<Either<ApiError, List<DiaryEntity>>> watchAll() =>
      const Stream.empty();

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
  Future<Either<ApiError, void>> delete(String diaryId) =>
      throw UnimplementedError();

  @override
  Future<Either<ApiError, List<CreateDiaryMediaRequest>>> uploadMediaFiles({
    required String diaryId,
    required List<File> files,
  }) {
    return uploadMediaFilesHandler(diaryId: diaryId, files: files);
  }
}
