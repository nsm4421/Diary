import 'dart:io';
import 'package:diary/core/extension/datetime_extension.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'schema/diary_media_table.dart';
import 'schema/diary_table.dart';

part 'local_database.g.dart';

@DriftDatabase(tables: [DiaryRecords, DiaryMediaRecords])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase._(QueryExecutor executor) : super(executor);

  factory LocalDatabase() => LocalDatabase._(_openConnection());

  // test용 local database는 in-memory database 사용
  factory LocalDatabase.test() => LocalDatabase._(NativeDatabase.memory());

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final dbPath = p.join(dir.path, 'diary.db');
      final file = File(dbPath);
      return NativeDatabase.createInBackground(file);
    });
  }

  @override
  int get schemaVersion => 1;
}
