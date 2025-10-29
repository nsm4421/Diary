import 'package:dartz/dartz.dart';
import 'package:diary/core/error/failure.dart';
import 'package:diary/domain/entity/diary_entry.dart';

abstract interface class DiaryRepository {
  Future<Either<Failure, DiaryEntry>> create({
    String? clientId,
    String? title,
    required String content,
  });

  Future<Either<Failure, DiaryEntry?>> findById(String id);

  Future<Either<Failure, List<DiaryEntry>>> fetchEntries({
    int limit = 20,
    required DateTime cursor,
  });

  Future<Either<Failure, List<DiaryEntry>>> searchByTitle({
    required String keyword,
    int limit = 20,
    required DateTime cursor,
  });

  Stream<Either<Failure, List<DiaryEntry>>> watchAll();

  Future<Either<Failure, DiaryEntry>> update({
    required String id,
    String? title,
    required String content,
  });

  Future<Either<Failure, void>> delete(String id);
}
