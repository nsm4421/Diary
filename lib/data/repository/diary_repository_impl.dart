import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:dartz/dartz.dart';
import 'package:diary/core/error/app_exception.dart';
import 'package:diary/core/error/error_handler.dart';
import 'package:diary/core/error/failure.dart';
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
    with ErrorHandlerMiIn, AppLoggerMixIn
    implements DiaryRepository {
  final LocalDiaryDbDataSource _database;
  final LocalDiaryFsDataSource _storage;

  DiaryRepositoryImpl(this._database, this._storage);

  @override
  Future<Either<Failure, DiaryEntity>> create({
    String? clientId,
    String? title,
    required String content,
    List<CreateDiaryMediaRequest> medias = const [],
  }) {
    return guard(
      () async => await _database
          .create(
            CreateDiaryRequestDto(
              clientId: clientId,
              title: title,
              content: content,
              medias: medias.map(_toDto).toList(growable: false),
            ),
          )
          .then((row) => row.toEntity()),
      logger: logger,
    );
  }

  @override
  Future<Either<Failure, DiaryEntity?>> findById(String diaryId) {
    return guard(
      () async =>
          await _database.findById(diaryId).then((row) => row?.toEntity()),

      logger: logger,
    );
  }

  @override
  Future<Either<Failure, DiaryDetailEntity?>> getDiaryDetail(String diaryId) {
    return guard(() async {
      final record = await _database.findById(diaryId);
      if (record == null) {
        return null;
      }

      final medias = await _database
          .fetchMedias(diaryId)
          .then(
            (res) => res
                .map(
                  (e) => e.toMediaEntity(
                    absolutePath: _storage.getAbsolutePath(e.relativePath),
                  ),
                )
                .toList(growable: false),
          );
      return record.toDetailEntity(medias);
    }, logger: logger);
  }

  @override
  Future<Either<Failure, List<DiaryEntity>>> fetchEntries({
    int limit = 20,
    required DateTime cursor,
  }) {
    return guard(
      () async => await _database
          .fetchRowsByCursor(limit: limit, cursor: cursor)
          .then(
            (rows) => rows.map((row) => row.toEntity()).toList(growable: false),
          ),
      logger: logger,
    );
  }

  @override
  Future<Either<Failure, List<DiaryEntity>>> searchByTitle({
    required String keyword,
    int limit = 20,
    required DateTime cursor,
  }) {
    return guard(
      () async => await _database
          .searchByTitle(keyword: keyword, limit: limit, cursor: cursor)
          .then(
            (rows) => rows.map((row) => row.toEntity()).toList(growable: false),
          ),
      logger: logger,
    );
  }

  @override
  Stream<Either<Failure, List<DiaryEntity>>> watchAll() {
    return _database.watchAll().transform(
      StreamTransformer<
        List<DiaryRecord>,
        Either<Failure, List<DiaryEntity>>
      >.fromHandlers(
        handleData: (rows, sink) {
          sink.add(
            Right<Failure, List<DiaryEntity>>(
              rows.map((row) => row.toEntity()).toList(growable: false),
            ),
          );
        },
        handleError: (error, stackTrace, sink) {
          final failure = (error is AppException)
              ? Failure.fromException(error)
              : Failure.unknown(
                  message: error.toString(),
                  stackTrace: stackTrace,
                );

          sink.add(Left<Failure, List<DiaryEntity>>(failure));
        },
      ),
    );
  }

  @override
  Future<Either<Failure, DiaryEntity>> update({
    required String diaryId,
    String? title,
    required String content,
    List<CreateDiaryMediaRequest> medias = const [],
  }) {
    return guard(() async {
      await _storage.deleteAll(diaryId);
      return await _database
          .update(
            UpdateDiaryRequestDto(
              id: diaryId,
              title: title,
              content: content,
              medias: medias.map(_toDto).toList(growable: false),
            ),
          )
          .then((row) => row.toEntity());
    }, logger: logger);
  }

  @override
  Future<Either<Failure, void>> delete(String diaryId) => guard(() async {
    await _storage.deleteAll(diaryId);
    await _database.delete(diaryId);
  });

  @override
  Future<Either<Failure, List<CreateDiaryMediaRequest>>> uploadMediaFiles({
    required String diaryId,
    required List<File> files,
  }) => guard(() async {
    final baseIndex = await _database
        .fetchMedias(diaryId)
        .then(
          (res) => res.isEmpty
              ? 0
              : res.map((e) => e.sortOrder).reduce(math.max) + 1,
        );

    final futures = files.asMap().entries.map((e) async {
      final index = e.key + baseIndex;
      final file = e.value;

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
}
