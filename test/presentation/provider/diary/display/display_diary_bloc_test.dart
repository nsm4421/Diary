import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:diary/core/error/api/api_error.dart';
import 'package:diary/core/extension/datetime_extension.dart';
import 'package:diary/core/value_objects/status.dart';
import 'package:diary/domain/entity/diary_entity.dart';
import 'package:diary/domain/entity/diary_detail_entity.dart';
import 'package:diary/domain/repository/diary_repository.dart';
import 'package:diary/domain/usecase/diary/diary_usecases.dart';
import 'package:diary/presentation/provider/diary/display/display_diary.bloc.dart';
import 'package:diary/presentation/provider/display/display_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late StubDiaryRepository repository;
  late DisplayDiaryBloc bloc;

  DiaryEntity diary(String id, DateTime createdAt) {
    return DiaryEntity(
      id: id,
      createdAt: createdAt.toUtc(),
      updatedAt: createdAt.toUtc(),
      date: createdAt.yyyymmdd,
      content: 'body of $id',
      title: 'title $id',
    );
  }

  setUp(() {
    repository = StubDiaryRepository();
    bloc = DisplayDiaryBloc(null, DiaryUseCases(repository));
  });

  tearDown(() async {
    await bloc.close();
  });

  Future<void> pumpEventQueue() async {
    await Future<void>.delayed(Duration.zero);
  }

  test('started loads first page and exposes next cursor', () async {
    repository.fetchEntriesHandler =
        ({int limit = 20, required DateTime cursor}) async {
          return Right([
            diary('recent', DateTime(2024, 4, 3, 12)),
            diary('older', DateTime(2024, 4, 1, 8)),
          ]);
        };

    bloc.add(const DisplayEvent<DiaryEntity>.started());
    await pumpEventQueue();

    expect(bloc.state.items.map((e) => e.id), ['recent', 'older']);
    expect(bloc.state.status, DisplayStatus.initial);
    expect(bloc.state.errorMessage, isNull);
    expect(bloc.state.nextCursor, DateTime(2024, 4, 1, 8).toUtc());
  });

  test('next page appends results and stops when end reached', () async {
    var callCount = 0;
    repository.fetchEntriesHandler =
        ({int limit = 20, required DateTime cursor}) async {
          callCount += 1;
          if (callCount == 1) {
            return Right([
              diary('page1-a', DateTime(2024, 5, 4)),
              diary('page1-b', DateTime(2024, 5, 3)),
            ]);
          }
          if (callCount == 2) {
            return Right([
              diary('page2-a', DateTime(2024, 5, 2)),
              diary('page2-b', DateTime(2024, 5, 1)),
            ]);
          }
          return const Right([]);
        };

    bloc.add(const DisplayEvent<DiaryEntity>.started());
    await pumpEventQueue();

    bloc.add(const DisplayEvent<DiaryEntity>.nextPageRequested());
    await pumpEventQueue();
    expect(bloc.state.items.map((e) => e.id), [
      'page1-a',
      'page1-b',
      'page2-a',
      'page2-b',
    ]);
    expect(bloc.state.nextCursor, DateTime(2024, 5, 1).toUtc());

    // third request still runs to confirm the end; afterwards nextCursor is null
    bloc.add(const DisplayEvent<DiaryEntity>.nextPageRequested());
    await pumpEventQueue();
    expect(callCount, 3);
    expect(bloc.state.isEnd, isTrue);
  });
}

class StubDiaryRepository implements DiaryRepository {
  Future<Either<ApiError, List<DiaryEntity>>> Function({
    int limit,
    required DateTime cursor,
  })?
  fetchEntriesHandler;

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
  Future<Either<ApiError, DiaryEntity>> create({
    String? clientId,
    String? title,
    required String content,
    List<CreateDiaryMediaRequest> medias = const [],
  }) =>
      throw UnimplementedError();

  @override
  Future<Either<ApiError, DiaryEntity?>> findById(String diaryId) =>
      throw UnimplementedError();

  @override
  Future<Either<ApiError, DiaryDetailEntity?>> getDiaryDetail(String diaryId) =>
      throw UnimplementedError();

  @override
  Future<Either<ApiError, void>> delete(String diaryId) =>
      throw UnimplementedError();

  @override
  Future<Either<ApiError, List<DiaryEntity>>> searchByTitle({
    required String keyword,
    int limit = 20,
    required DateTime cursor,
  }) =>
      throw UnimplementedError();

  @override
  Future<Either<ApiError, List<DiaryEntity>>> searchByContent({
    required String keyword,
    int limit = 20,
    required DateTime cursor,
  }) =>
      throw UnimplementedError();

  @override
  Future<Either<ApiError, List<DiaryEntity>>> searchByDateRange({
    required DateTime start,
    required DateTime end,
    int limit = 20,
    required DateTime cursor,
  }) =>
      throw UnimplementedError();

  @override
  Stream<Either<ApiError, List<DiaryEntity>>> watchAll() =>
      throw UnimplementedError();

  @override
  Future<Either<ApiError, DiaryEntity>> update({
    required String diaryId,
    String? title,
    required String content,
    List<CreateDiaryMediaRequest> medias = const [],
  }) =>
      throw UnimplementedError();

  @override
  Future<Either<ApiError, List<CreateDiaryMediaRequest>>> uploadMediaFiles({
    required String diaryId,
    required List<File> files,
  }) =>
      throw UnimplementedError();
}
