import 'package:diary/data/datasoure/local/database/local_database.dart';
import 'package:diary/domain/entity/diary_entry.dart';

extension DiaryRecordMapper on DiaryRecord {
  DiaryEntry toEntity() {
    return DiaryEntry(
      id: id,
      title: title,
      content: content,
      isTemp: isTemp,
      createdAt: createdAt,
      updatedAt: updatedAt,
      date: date,
    );
  }
}
