import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'diary_table.dart';

class DiaryMediaRecords extends Table {
  TextColumn get id =>
      text().withLength(min: 1, max: 36).clientDefault(() => Uuid().v4())();

  TextColumn get diaryId => text().references(
        DiaryRecords,
        #id,
        onDelete: KeyAction.cascade,
        onUpdate: KeyAction.cascade,
      )();

  TextColumn get relativePath =>
      text().withLength(min: 1, max: 1024)();

  TextColumn get fileName =>
      text().withLength(min: 1, max: 255)();

  TextColumn get mimeType =>
      text().withLength(min: 1, max: 128).nullable()();

  IntColumn get sizeInBytes =>
      integer().nullable()();

  IntColumn get width =>
      integer().nullable()();

  IntColumn get height =>
      integer().nullable()();

  IntColumn get sortOrder =>
      integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {diaryId, relativePath},
      ];
}
