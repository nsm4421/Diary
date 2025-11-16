import 'dart:io';
import 'dart:typed_data';

import 'package:diary/core/value_objects/storage.dart';
import 'package:diary/data/datasoure/fs/local_fs_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:image/image.dart' as img;

import '../../../mock_logger.dart';

void main() {
  late Directory baseDir;
  late LocalFileSystemDataSource storage;
  late Directory rootDir;

  setUp(() async {
    baseDir = await Directory.systemTemp.createTemp('local_storage_test');
    storage = LocalFileSystemDataSourceImpl(
      baseDirectory: baseDir,
      rootFolder: 'root',
      logger: MockLogger(),
    );
    rootDir = Directory(p.join(baseDir.path, 'root'));
  });

  tearDown(() async {
    if (await baseDir.exists()) {
      await baseDir.delete(recursive: true);
    }
  });

  Future<File> _fileAt(String relativePath) async {
    return File(p.join(rootDir.path, relativePath));
  }

  test('save writes file to disk', () async {
    final data = Uint8List.fromList(List<int>.filled(128 * 1024, 3));

    final savedPath = await storage.save(
      relativePath: 'photos/sample.bin',
      bytes: data,
    );

    final file = await _fileAt('photos/sample.bin');
    expect(file.existsSync(), isTrue);
    expect(file.readAsBytesSync(), data);
    expect(savedPath, file.path);
  });

  test('save throws when file exists and overwrite is false', () async {
    final path = 'photos/existing.bin';
    final data = Uint8List.fromList(List<int>.filled(10, 1));

    await storage.save(relativePath: path, bytes: data);

    expect(
      () => storage.save(relativePath: path, bytes: data),
      throwsA(isA<FileSystemException>()),
    );
  });

  test('save overwrites file when overwrite true', () async {
    final path = 'photos/overwrite.bin';
    final original = Uint8List.fromList(List<int>.filled(10, 5));
    final updated = Uint8List.fromList(List<int>.filled(12, 7));

    await storage.save(relativePath: path, bytes: original);
    await storage.save(relativePath: path, bytes: updated, overwrite: true);

    final file = await _fileAt(path);
    expect(file.readAsBytesSync(), updated);
  });

  test('save resizes image with maintainAspectRatio', () async {
    final image = img.Image(width: 400, height: 200);
    final sourceBytes = Uint8List.fromList(img.encodeJpg(image));

    final savedPath = await storage.save(
      relativePath: 'photos/resized.jpg',
      bytes: sourceBytes,
      resize: const ResizeOption(width: 100),
    );

    final resizedBytes = await File(savedPath).readAsBytes();
    final resizedImage = img.decodeImage(resizedBytes)!;

    expect(resizedImage.width, equals(100));
    expect(resizedImage.height, equals(50));
  });

  test('read returns null for missing file', () async {
    final result = await storage.read('missing/file.txt');
    expect(result, isNull);
  });

  test('read returns stored bytes', () async {
    const path = 'photos/read.bin';
    final data = Uint8List.fromList([9, 8, 7, 6]);

    await storage.save(relativePath: path, bytes: data);
    final readBack = await storage.read(path);

    expect(readBack, isNotNull);
    expect(readBack, data);
  });

  test('exists reflects file presence', () async {
    const path = 'photos/check.bin';
    final data = Uint8List.fromList([1, 2, 3]);

    expect(await storage.exists(path), isFalse);
    await storage.save(relativePath: path, bytes: data);
    expect(await storage.exists(path), isTrue);
  });

  test('delete removes file', () async {
    const path = 'photos/delete.bin';
    final data = Uint8List.fromList([4, 5, 6]);

    await storage.save(relativePath: path, bytes: data);
    final file = await _fileAt(path);
    expect(file.existsSync(), isTrue);

    await storage.delete(path);
    expect(file.existsSync(), isFalse);
  });

  test('deleteAll removes nested directory only', () async {
    await storage.save(
      relativePath: 'albums/1/photo_a.bin',
      bytes: Uint8List.fromList([1]),
    );
    await storage.save(
      relativePath: 'albums/1/photo_b.bin',
      bytes: Uint8List.fromList([2]),
    );
    await storage.save(
      relativePath: 'albums/2/photo_c.bin',
      bytes: Uint8List.fromList([3]),
    );

    await storage.deleteAll('albums/1');

    expect(await Directory(p.join(rootDir.path, 'albums/1')).exists(), isFalse);
    expect(await Directory(p.join(rootDir.path, 'albums/2')).exists(), isTrue);
  });
}
