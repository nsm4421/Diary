import 'package:diary/core/extension/datetime_extension.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class DiaryRecords extends Table {
  TextColumn get id =>
      text().withLength(min: 1, max: 36).clientDefault(() => (Uuid()).v4())();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => (DateTime.now().toUtc()))();

  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => (DateTime.now().toUtc()))();

  TextColumn get date =>
      text().clientDefault(() => (DateTime.now().yyyymmdd))();

  BoolColumn get isTemp => boolean().withDefault(const Constant(false))();

  TextColumn get title => text().withLength(min: 0, max: 30).nullable()();

  TextColumn get content => text().withLength(min: 0, max: 5000)();

  @override
  Set<Column> get primaryKey => {id};
}
