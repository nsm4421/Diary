import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:diary/core/error/app_exception.dart';
import 'package:diary/core/error/error_handler.dart';
import 'package:diary/core/error/failure.dart';
import 'package:diary/core/extension/file_extension.dart';
import 'package:diary/data/datasoure/local/database/local_database.dart';
import 'package:diary/data/datasoure/local/diary/dto.dart';
import 'package:diary/data/datasoure/local/diary/local_diary_datasource.dart';
import 'package:diary/data/datasoure/local/diary/local_diary_storage.dart';
import 'package:diary/data/model/diary/mapper.dart';
import 'package:diary/domain/entity/diary_entry.dart';
import 'package:diary/domain/repository/diary/diary_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DiaryRepository)
class DiaryRepositoryImpl with ErrorHandlerMiIn implements DiaryRepository {
  final LocalDiaryDataSource _database;
  final LocalDiaryStorage _storage;

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
    );
  }

  @override
  Future<Either<Failure, DiaryEntity?>> findById(String diaryId) {
    return guard(
      () async =>
          await _database.findById(diaryId).then((row) => row?.toEntity()),
    );
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
    });
  }

  @override
  Future<Either<Failure, void>> delete(String diaryId) => guard(() async {
    await _storage.deleteAll(diaryId);
    await _database.delete(diaryId);
  });

  @override
  Future<Either<Failure, List<String>>> uploadMediaFiles({
    required String diaryId,
    required List<File> files,
  }) => guard(() async {
    final futures = files.asMap().entries.map(
      (e) async => await _storage.save(
        diaryId: diaryId,
        bytes: await e.value.readAsBytes(),
        fileName: e.value.filename,
      ),
    );
    return await Future.wait(futures);
  });

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
