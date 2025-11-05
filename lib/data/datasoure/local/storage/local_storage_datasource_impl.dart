part of 'local_storage_datasource.dart';

class LocalStorageDataSourceImpl
    with ImageUtilMixIn, FsUtilMixIn
    implements LocalStorageDataSource {
  LocalStorageDataSourceImpl({
    required Directory baseDirectory,
    String rootFolder = 'storage',
    required Logger logger,
  }) : _baseDirectory = baseDirectory,
       _rootFolder = rootFolder,
       _logger = logger;

  final Directory _baseDirectory;
  final String _rootFolder;
  final Logger _logger;

  @override
  Directory get workingDirectory =>
      Directory(p.join(_baseDirectory.path, _rootFolder));

  @override
  Future<String> save({
    required String relativePath,
    required Uint8List bytes,
    bool overwrite = false,
    ResizeOption? resize,
    void Function(double pct)? onProgress,
  }) async {
    try {
      // check target file
      final targetFile = await resolveFile(
        baseDirectory: _baseDirectory,
        rootFolder: _rootFolder,
        relativePath: relativePath,
      );
      final targetFileExistence = await targetFile.exists();
      if (!overwrite && targetFileExistence) {
        throw FileSystemException('File already exists', targetFile.path);
      } else if (overwrite && targetFileExistence) {
        await targetFile.delete();
      } else {
        await targetFile.parent.create(recursive: true);
      }

      // save file
      await writeWithProgress(
        file: targetFile,
        bytes: resize == null
            ? bytes
            : await tryResize(
                bytes: bytes,
                resize: resize,
                targetExtension: p.extension(targetFile.path).toLowerCase(),
              ),
        onProgress: onProgress,
      );

      // return saved file path
      return targetFile.path;
    } catch (e, st) {
      _logger.w('fail to write file', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<Uint8List?> read(String relativePath) async {
    try {
      final file = await resolveFile(
        baseDirectory: _baseDirectory,
        rootFolder: _rootFolder,
        relativePath: relativePath,
      );
      final fileExistence = await file.exists();

      return fileExistence ? await file.readAsBytes() : null;
    } catch (e, st) {
      _logger.w('Failed to read file: $relativePath', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<bool> exists(String relativePath) async {
    try {
      final file = await resolveFile(
        baseDirectory: _baseDirectory,
        rootFolder: _rootFolder,
        relativePath: relativePath,
      );
      return file.exists();
    } catch (e, st) {
      _logger.w(
        'Failed to check existence of file located at $relativePath',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  @override
  Future<void> delete(String relativePath, {bool ignoreMissing = true}) async {
    try {
      final file = await resolveFile(
        baseDirectory: _baseDirectory,
        rootFolder: _rootFolder,
        relativePath: relativePath,
      );
      ;
      final fileExistence = await file.exists();
      if (!fileExistence && !ignoreMissing) {
        throw FileSystemException('file is missing at $relativePath');
      } else if (fileExistence) {
        await file.delete();
      }
    } catch (e, st) {
      _logger.e(e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> deleteAll(String directory, {bool ignoreMissing = true}) async {
    try {
      final dir = await resolveDirectory(
        baseDirectory: _baseDirectory,
        rootFolder: _rootFolder,
        relativePath: directory,
      );
      final dirExistence = await dir.exists();
      if (!dirExistence && !ignoreMissing) {
        throw FileSystemException('directory is missing at $directory');
      } else if (dirExistence) {
        await dir.delete(recursive: true);
      }
    } catch (e, st) {
      _logger.e(e, stackTrace: st);
      rethrow;
    }
  }
}
