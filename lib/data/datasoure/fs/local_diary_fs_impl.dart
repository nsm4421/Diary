part of 'local_diary_fs_datasource.dart';

class LocalDiaryFsStorageImpl implements LocalDiaryFsDataSource {
  final LocalFileSystemDataSource _localStorage;

  LocalDiaryFsStorageImpl(this._localStorage);

  @override
  String getAbsolutePath(String relativePath) {
    return p.join(_localStorage.workingDirectory.path, relativePath);
  }

  @override
  Future<String> save({
    required String diaryId,
    required Uint8List bytes,
    required String fileName,
    bool overwrite = false,
    int index = 0,
    ResizeOption? resize,
  }) async {
    return await _localStorage.save(
      relativePath: _buildRelativePath(
        diaryId: diaryId,
        index: index,
        fileName: fileName,
      ),
      bytes: bytes,
      overwrite: overwrite,
      resize: resize,
    );
  }

  @override
  Future<void> deleteAll(String diaryId) async {
    return await _localStorage.deleteAll(_buildDirectory(diaryId));
  }

  @override
  Future<void> delete(String relativePath) async {
    await _localStorage.delete(relativePath);
  }

  String _buildDirectory(String diaryId) {
    return p.join('diary', diaryId);
  }

  String _buildRelativePath({
    required String diaryId,
    required int index,
    required String fileName,
  }) {
    final trimmed = fileName.trim();
    var extension = p.extension(trimmed).toLowerCase();
    final baseName = p.basenameWithoutExtension(trimmed).trim();
    final isDotFile =
        extension.isEmpty && trimmed.startsWith('.') && trimmed.length > 1;
    if (isDotFile) {
      extension = trimmed.toLowerCase();
    }
    final prefix = '${index.toString().padLeft(4, '0')}_';
    return p.join(
      'diary',
      diaryId,
      '$prefix${(isDotFile || baseName.isEmpty) ? 'media' : baseName}$extension',
    );
  }
}
