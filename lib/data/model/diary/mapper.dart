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

  DiaryDetailEntity toDetailEntity(List<DiaryMediaAsset> medias) {
    return DiaryDetailEntity(
      id: id,
      title: title,
      content: content,
      isTemp: isTemp,
      createdAt: createdAt,
      updatedAt: updatedAt,
      date: date,
      medias: medias,
    );
  }
}

extension DiaryMediaRecordMapper on DiaryMediaRecord {
  DiaryMediaAsset toMediaEntity() {
    return DiaryMediaAsset(
      relativePath: relativePath,
      fileName: fileName,
      mimeType: mimeType,
      sizeInBytes: sizeInBytes,
      width: width,
      height: height,
      sortOrder: sortOrder,
    );
  }
}
