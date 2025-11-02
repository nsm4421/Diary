import 'package:diary/core/utils/fs_util.dart';
import 'package:diary/core/utils/image_util.dart';
import 'package:diary/core/value_objects/storage.dart';

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;

part 'local_storage_datasource_impl.dart';

abstract interface class LocalStorageDataSource {
  Future<String> save({
    required String relativePath,
    required Uint8List bytes,
    bool overwrite = false,
    ResizeOption? resize,
  });

  Future<Uint8List?> read(String relativePath);

  Future<bool> exists(String relativePath);

  Future<void> delete(String relativePath);

  Future<void> deleteAll(String directory);
}
