import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:dartz/dartz.dart';
import 'package:diary/core/value_objects/error/api_error.dart';
import 'package:diary/core/value_objects/error/api_exception.dart';
import 'package:diary/core/utils/api_error_handler.dart';
import 'package:diary/core/extension/file_extension.dart';
import 'package:diary/core/extension/string_extension.dart';
import 'package:diary/core/utils/app_logger.dart';
import 'package:diary/data/datasoure/database/dao/local_database.dart';
import 'package:diary/data/datasoure/database/dto.dart';
import 'package:diary/data/datasoure/database/local_diary_db_datasource.dart';
import 'package:diary/data/datasoure/fs/local_diary_fs_datasource.dart';
import 'package:diary/data/model/diary/mapper.dart';
import 'package:diary/domain/entity/diary_detail_entity.dart';
import 'package:diary/domain/entity/diary_entity.dart';

import 'package:diary/domain/repository/diary_repository.dart';
import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';

@LazySingleton(as: DiaryRepository)
class DiaryRepositoryImpl
    with ApiErrorHandlerMiIn, AppLoggerMixIn
    implements DiaryRepository {
  final LocalDiaryDbDataSource _database;
  final LocalDiaryFsDataSource _storage;

  DiaryRepositoryImpl(this._database, this._storage);

  @override
  Future<Either<ApiError, DiaryEntity>> create({
    String? clientId,
    String? title,
    required String content,
    List<CreateDiaryMediaRequest> medias = const [],
  }) {
    return guard(() async {
      final row = await runDatabase(
        () => _database.create(
          CreateDiaryRequestDto(
            clientId: clientId,
            title: title,
            content: content,
            medias: medias.map(_toDto).toList(growable: false),
          ),
        ),
      );
      return row.toEntity();
    }, logger: logger);
  }

  @override
  Future<Either<ApiError, DiaryEntity?>> findById(String diaryId) {
    return guard(() async {
      final row = await runDatabase(() => _database.findById(diaryId));
      return row?.toEntity();
    }, logger: logger);
  }

  @override
  Future<Either<ApiError, DiaryDetailEntity?>> getDiaryDetail(String diaryId) {
    return guard(() async {
      final record = await runDatabase(() => _database.findById(diaryId));
      if (record == null) {
        return null;
      }
      final medias = await runDatabase(() => _database.fetchMedias(diaryId));
      final mediaEntities = medias
          .map(
            (e) => e.toMediaEntity(
              absolutePath: _storage.getAbsolutePath(e.relativePath),
            ),
          )
          .toList(growable: false);
      return record.toDetailEntity(mediaEntities);
    }, logger: logger);
  }

  @override
  Future<Either<ApiError, List<DiaryEntity>>> fetchDiaries({
    int limit = 20,
    required DateTime cursor,
  }) {
    return guard(() async {
      final rows = await runDatabase(
        () => _database.fetchRowsByCursor(limit: limit, cursor: cursor),
      );
      return rows.map((row) => row.toEntity()).toList(growable: false);
    }, logger: logger);
  }

  @override
  Future<Either<ApiError, List<DiaryEntity>>> searchByTitle({
    required String keyword,
    int limit = 20,
    required DateTime cursor,
  }) {
    return guard(() async {
      final rows = await runDatabase(
        () => _database.searchByTitle(
          keyword: keyword,
          limit: limit,
          cursor: cursor,
        ),
      );
      return rows.map((row) => row.toEntity()).toList(growable: false);
    }, logger: logger);
  }

  @override
  Future<Either<ApiError, List<DiaryEntity>>> searchByContent({
    required String keyword,
    int limit = 20,
    required DateTime cursor,
  }) {
    return guard(() async {
      final rows = await runDatabase(
        () => _database.searchByContent(
          keyword: keyword,
          limit: limit,
          cursor: cursor,
        ),
      );
      return rows.map((row) => row.toEntity()).toList(growable: false);
    }, logger: logger);
  }

  @override
  Future<Either<ApiError, List<DiaryEntity>>> searchByDateRange({
    required DateTime start,
    required DateTime end,
    int limit = 20,
    required DateTime cursor,
  }) {
    return guard(() async {
      final rows = await runDatabase(
        () => _database.searchByDateRange(
          start: start,
          end: end,
          limit: limit,
          cursor: cursor,
        ),
      );
      return rows.map((row) => row.toEntity()).toList(growable: false);
    }, logger: logger);
  }

  @override
  Stream<Either<ApiError, List<DiaryEntity>>> watchAll() {
    return _database.watchAll().transform(
      StreamTransformer<
        List<DiaryRecord>,
        Either<ApiError, List<DiaryEntity>>
      >.fromHandlers(
        handleData: (rows, sink) {
          sink.add(
            Right<ApiError, List<DiaryEntity>>(
              rows.map((row) => row.toEntity()).toList(growable: false),
            ),
          );
        },
        handleError: (error, stackTrace, sink) {
          final apiError = error is ApiException
              ? error.toApiError()
              : ApiException.database(
                  message: error.toString(),
                  details: error,
                  stackTrace: stackTrace,
                ).toApiError();
          sink.add(Left<ApiError, List<DiaryEntity>>(apiError));
        },
      ),
    );
  }

  @override
  Future<Either<ApiError, DiaryEntity>> update({
    required String diaryId,
    String? title,
    required String content,
    List<CreateDiaryMediaRequest> medias = const [],
  }) {
    return guard(() async {
      await runStorage(() => _storage.deleteAll(diaryId));
      final row = await runDatabase(
        () => _database.update(
          UpdateDiaryRequestDto(
            id: diaryId,
            title: title,
            content: content,
            medias: medias.map(_toDto).toList(growable: false),
          ),
        ),
      );
      return row.toEntity();
    }, logger: logger);
  }

  @override
  Future<Either<ApiError, void>> delete(String diaryId) => guard(() async {
    await runStorage(() => _storage.deleteAll(diaryId));
    await runDatabase(() => _database.delete(diaryId));
  }, logger: logger);

  @override
  Future<Either<ApiError, List<CreateDiaryMediaRequest>>> uploadMediaFiles({
    required String diaryId,
    required List<File> files,
  }) => guard(() async {
    final medias = await runDatabase(() => _database.fetchMedias(diaryId));
    final baseIndex = medias.isEmpty
        ? 0
        : medias.map((e) => e.sortOrder).reduce(math.max) + 1;

    final futures = files.asMap().entries.map((entry) async {
      return runStorage(() async {
        final index = entry.key + baseIndex;
        final file = entry.value;
        final bytes = await file.readAsBytes();
        final relativePath = await _storage.save(
          diaryId: diaryId,
          bytes: bytes,
          fileName: file.filename,
          index: index,
        );

        final decoded = img.decodeImage(bytes);
        return CreateDiaryMediaRequest(
          relativePath: relativePath,
          fileName: file.filename,
          mimeType: file.filename.mimeType,
          sizeInBytes: bytes.length,
          width: decoded?.width,
          height: decoded?.height,
          sortOrder: index,
        );
      });
    });

    return await Future.wait(futures);
  }, logger: logger);

  CreateDiaryMediaRequestDto _toDto(CreateDiaryMediaRequest param) {
    return CreateDiaryMediaRequestDto(
      relativePath: param.relativePath,
      fileName: param.fileName,
      mimeType: param.mimeType,
      sizeInBytes: param.sizeInBytes,
      width: param.width,
      height: param.height,
      sortOrder: param.sortOrder,
    );
  }

  @override
  Future<Either<ApiError, List<DiaryEntity>>> findAllByDateRange({
    required DateTime start,
    required DateTime end,
  }) {
    return guard(() async {
      final rows = await runDatabase(
        () => _database.findAllByDateRange(start: start, end: end),
      );
      return rows.map((row) => row.toEntity()).toList(growable: false);
    }, logger: logger);
  }
}
