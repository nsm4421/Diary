import 'package:diary/data/datasoure/local/database/schema/diary_media_table.dart';
import 'package:drift/drift.dart';
import 'local_database.dart';
import 'schema/diary_table.dart';

part 'local_database_dao.g.dart';

@DriftAccessor(tables: [DiaryRecords, DiaryMediaRecords])
class LocalDatabaseDao extends DatabaseAccessor<LocalDatabase>
    with _$LocalDatabaseDaoMixin {
  LocalDatabaseDao(super.db);
}
