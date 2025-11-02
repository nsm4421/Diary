import 'dart:typed_data';

import 'package:diary/core/value_objects/storage.dart';
import 'package:diary/data/datasoure/local/storage/local_storage_datasource.dart';
import 'package:path/path.dart' as p;

part 'local_diary_storage_impl.dart';

abstract interface class LocalDiaryStorage {
  Future<String> save({
    required String diaryId,
    required Uint8List bytes,
    required String fileName,
    bool overwrite = false,
    int index = 0,
    ResizeOption? resize,
  });

  Future<void> delete(String relativePath);

  Future<void> deleteAll(String diaryId);
}
