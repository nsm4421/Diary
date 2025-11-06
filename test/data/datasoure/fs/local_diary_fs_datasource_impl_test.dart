import 'dart:io';
import 'dart:typed_data';

import 'package:diary/core/value_objects/storage.dart';
import 'package:diary/data/datasoure/fs/local_diary_fs_datasource.dart';
import 'package:diary/data/datasoure/fs/local_fs_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

class _FakeLocalFileSystemDataSource implements LocalFileSystemDataSource {
  _FakeLocalFileSystemDataSource(this._directory);

  final Directory _directory;

  final List<_SaveCall> saveCalls = [];
  final List<String> deleteCalls = [];
  final List<String> deleteAllCalls = [];

  @override
  Directory get workingDirectory => _directory;

  @override
  Future<String> save({
    required String relativePath,
    required Uint8List bytes,
    bool overwrite = false,
    ResizeOption? resize,
  }) async {
    saveCalls.add(
      _SaveCall(
        relativePath: relativePath,
        bytes: bytes,
        overwrite: overwrite,
        resize: resize,
      ),
    );
    return p.join(_directory.path, relativePath);
  }

  @override
  Future<Uint8List?> read(String relativePath) async => null;

  @override
  Future<bool> exists(String relativePath) async => false;

  @override
  Future<void> delete(String relativePath) async {
    deleteCalls.add(relativePath);
  }

  @override
  Future<void> deleteAll(String directory) async {
    deleteAllCalls.add(directory);
  }
}

class _SaveCall {
  _SaveCall({
    required this.relativePath,
    required this.bytes,
    required this.overwrite,
    required this.resize,
  });

  final String relativePath;
  final Uint8List bytes;
  final bool overwrite;
  final ResizeOption? resize;
}

void main() {
  late _FakeLocalFileSystemDataSource localFs;
  late LocalDiaryFsDataSource dataSource;
  late Directory baseDirectory;

  setUp(() {
    baseDirectory = Directory('/tmp/diary_fs_test');
    localFs = _FakeLocalFileSystemDataSource(baseDirectory);
    dataSource = LocalDiaryFsStorageImpl(localFs);
  });

  test('getAbsolutePath joins working directory with relative path', () {
    final relative = 'diary/abc/0001_photo.jpg';

    final absolute = dataSource.getAbsolutePath(relative);

    expect(absolute, p.join(baseDirectory.path, relative));
  });

  test('save delegates to LocalFileSystemDataSource with generated path', () async {
    final bytes = Uint8List.fromList([1, 2, 3]);

    final savedPath = await dataSource.save(
      diaryId: 'diary-1',
      bytes: bytes,
      fileName: 'My Photo.JPG',
      index: 7,
      overwrite: true,
    );

    expect(localFs.saveCalls, hasLength(1));
    final call = localFs.saveCalls.first;
    expect(call.relativePath, 'diary/diary-1/0007_My Photo.jpg');
    expect(call.bytes, bytes);
    expect(call.overwrite, isTrue);
    expect(call.resize, isNull);
    expect(savedPath, p.join(baseDirectory.path, call.relativePath));
  });

  test('save ensures generated filename when base name empty', () async {
    final bytes = Uint8List.fromList([1]);

    await dataSource.save(
      diaryId: 'diary-2',
      bytes: bytes,
      fileName: '.png',
      index: 0,
    );

    expect(localFs.saveCalls, hasLength(1));
    expect(
      localFs.saveCalls.first.relativePath,
      'diary/diary-2/0000_media.png',
    );
  });

  test('delete forwards relative path to LocalFileSystemDataSource', () async {
    await dataSource.delete('diary/abc/0001_photo.jpg');

    expect(localFs.deleteCalls, ['diary/abc/0001_photo.jpg']);
  });

  test('deleteAll forwards diary directory to LocalFileSystemDataSource', () async {
    await dataSource.deleteAll('diary-3');

    expect(localFs.deleteAllCalls, ['diary/diary-3']);
  });
}
