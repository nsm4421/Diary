part of 'local_diary_storage.dart';

class LocalDiaryStorageImpl implements LocalDiaryStorage {
  final LocalStorageDataSource _localStorage;

  LocalDiaryStorageImpl(this._localStorage);

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
    final extension = p.extension(fileName).toLowerCase();
    final baseName = p.basenameWithoutExtension(fileName);
    final prefix = '${index.toString().padLeft(4, '0')}_';
    return p.join(
      'diary',
      diaryId,
      '$prefix${baseName.isEmpty ? 'media' : baseName}$extension',
    );
  }
}
