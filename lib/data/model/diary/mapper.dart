import 'package:diary/core/value_objects/domain/diary_mood.dart';
import 'package:diary/data/datasoure/database/dao/local_database.dart';
import 'package:diary/domain/entity/diary_detail_entity.dart';
import 'package:diary/domain/entity/diary_entity.dart';
import 'package:diary/domain/entity/diary_media_asset.dart';

extension DiaryRecordMapper on DiaryRecord {
  DiaryEntity toEntity() {
    return DiaryEntity(
      id: id,
      title: title,
      content: content,
      mood: mood ?? DiaryMood.none,
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
      mood: mood ?? DiaryMood.none,
      createdAt: createdAt,
      updatedAt: updatedAt,
      date: date,
      medias: medias,
    );
  }
}

extension DiaryMediaRecordMapper on DiaryMediaRecord {
  DiaryMediaAsset toMediaEntity({required String absolutePath}) {
    return DiaryMediaAsset(
      absolutePath: absolutePath,
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
