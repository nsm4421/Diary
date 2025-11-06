import 'package:diary/data/datasoure/secure_storage/password_secure_storage_datasource.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const key = 'secure.password.hash';
  late TestFlutterSecureStoragePlatform platform;
  late FlutterSecureStorage storage;
  late PasswordSecureStorageDataSource dataSource;
  late FlutterSecureStoragePlatform previousPlatform;

  setUp(() {
    previousPlatform = FlutterSecureStoragePlatform.instance;
    platform = TestFlutterSecureStoragePlatform({});
    FlutterSecureStoragePlatform.instance = platform;
    storage = const FlutterSecureStorage();
    dataSource = PasswordSecureStorageDataSourceImpl(storage);
  });

  tearDown(() {
    FlutterSecureStoragePlatform.instance = previousPlatform;
  });

  test('savePasswordHash writes hash to secure storage', () async {
    await dataSource.savePasswordHash('hashed-password');

    expect(platform.data[key], 'hashed-password');
  });

  test('fetchPasswordHash returns stored hash', () async {
    platform.data[key] = 'existing-hash';

    final hash = await dataSource.fetchPasswordHash();
    expect(hash, 'existing-hash');
  });

  test('fetchPasswordHash returns null when missing', () async {
    final hash = await dataSource.fetchPasswordHash();
    expect(hash, isNull);
  });

  test('clearPassword removes stored hash', () async {
    platform.data[key] = 'to-be-cleared';

    await dataSource.clearPassword();

    expect(platform.data.containsKey(key), isFalse);
  });
}
