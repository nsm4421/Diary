import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:diary/core/error/app_exception.dart';
import 'package:diary/core/error/error_handler.dart';
import 'package:diary/core/error/failure.dart';
import 'package:diary/data/datasoure/local/database/local_database.dart';
import 'package:diary/data/datasoure/local/diary/dto.dart';
import 'package:diary/data/datasoure/local/diary/local_diary_datasource.dart';
import 'package:diary/data/model/diary/mapper.dart';
import 'package:diary/domain/entity/diary_entry.dart';
import 'package:diary/domain/repository/diary_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DiaryRepository)
class DiaryRepositoryImpl with ErrorHandlerMiIn implements DiaryRepository {
  final LocalDiaryDataSource _localDataSource;

  DiaryRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, DiaryEntry>> create({
    String? clientId,
    String? title,
    required String content,
  }) {
    return guard(
      () async => await _localDataSource
          .create(
            CreateDiaryRequestDto(
              clientId: clientId,
              title: title,
              content: content,
            ),
          )
          .then((row) => row.toEntity()),
    );
  }

  @override
  Future<Either<Failure, DiaryEntry?>> findById(String id) {
    return guard(
      () async =>
          await _localDataSource.findById(id).then((row) => row?.toEntity()),
    );
  }

  @override
  Future<Either<Failure, List<DiaryEntry>>> fetchEntries({
    int limit = 20,
    required DateTime cursor,
  }) {
    return guard(
      () async => await _localDataSource
          .fetchRowsByCursor(limit: limit, cursor: cursor)
          .then(
            (rows) => rows.map((row) => row.toEntity()).toList(growable: false),
          ),
    );
  }

  @override
  Future<Either<Failure, List<DiaryEntry>>> searchByTitle({
    required String keyword,
    int limit = 20,
    required DateTime cursor,
  }) {
    return guard(
      () async => await _localDataSource
          .searchByTitle(keyword: keyword, limit: limit, cursor: cursor)
          .then(
            (rows) => rows.map((row) => row.toEntity()).toList(growable: false),
          ),
    );
  }

  @override
  Stream<Either<Failure, List<DiaryEntry>>> watchAll() {
    return _localDataSource.watchAll().transform(
      StreamTransformer<
        List<DiaryRecord>,
        Either<Failure, List<DiaryEntry>>
      >.fromHandlers(
        handleData: (rows, sink) {
          sink.add(
            Right<Failure, List<DiaryEntry>>(
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

          sink.add(Left<Failure, List<DiaryEntry>>(failure));
        },
      ),
    );
  }

  @override
  Future<Either<Failure, DiaryEntry>> update({
    required String id,
    String? title,
    required String content,
  }) {
    return guard(
      () async => await _localDataSource
          .update(UpdateDiaryRequestDto(id: id, title: title, content: content))
          .then((row) => row.toEntity()),
    );
  }

  @override
  Future<Either<Failure, void>> delete(String id) {
    return guard(() async => _localDataSource.delete(id));
  }
}
