import 'package:diary/data/datasoure/local/database/local_database.dart';
import 'package:diary/domain/entity/diary_entry.dart';

extension DiaryRecordMapper on DiaryRecord {
  DiaryEntity toEntity() {
    return DiaryEntity(
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
