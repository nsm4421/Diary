import 'dart:io';
import 'dart:typed_data';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;

@lazySingleton
mixin class FsUtilMixIn {
  Future<Directory> getRootDir({
    required Directory baseDirectory,
    String rootFolder = 'root',
  }) async {
    final rootPath = p.join(baseDirectory.path, rootFolder);
    final rootDir = Directory(rootPath);
    final rootDirExistence = await rootDir.exists();
    if (!rootDirExistence) {
      await rootDir.create(recursive: true);
    }
    return rootDir;
  }

  Future<File> resolveFile({
    required Directory baseDirectory,
    String rootFolder = 'root',
    required String relativePath,
  }) async {
    final rootDir = await this.getRootDir(
      baseDirectory: baseDirectory,
      rootFolder: rootFolder,
    );
    return File(p.join(rootDir.path, relativePath));
  }

  Future<Directory> resolveDirectory({
    required Directory baseDirectory,
    String rootFolder = 'root',
    required String relativePath,
  }) async {
    final rootDir = await getRootDir(
      baseDirectory: baseDirectory,
      rootFolder: rootFolder,
    );
    return Directory(p.join(rootDir.path, relativePath));
  }

  Future<void> writeWithProgress({
    required File file,
    required Uint8List bytes,
    void Function(double pct)? onProgress,
  }) async {
    const chunkSize = 64 * 1024; // 64 KB
    final total = bytes.length;

    final raf = await file.open(mode: FileMode.write);
    try {
      int offset = 0;
      if (onProgress != null) {
        onProgress(0);
      }

      while (offset < total) {
        final end = (offset + chunkSize < total) ? offset + chunkSize : total;
        await raf.writeFrom(bytes, offset, end);
        offset = end;
        if (onProgress != null && total > 0) {
          onProgress(offset / total);
        }
      }

      if (onProgress != null && total == 0) {
        onProgress(1);
      }
    } finally {
      await raf.close();
    }
  }
}
