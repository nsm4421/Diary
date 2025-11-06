import 'dart:io';

import 'package:diary/data/datasoure/fs/local_diary_fs_datasource.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database/local_diary_db_datasource.dart';
import 'database/dao/local_database.dart';
import 'database/dao/local_database_dao.dart';
import 'fs/local_fs_datasource.dart';
import 'secure_storage/password_secure_storage_datasource.dart';
import 'shared_preference/settings_preferences_datasource.dart';

@module
abstract class LocalDatasourceModule {
  final _dao = LocalDatabaseDao(LocalDatabase());
  final _logger = Logger();

  @lazySingleton
  LocalDiaryDbDataSource get diary => LocalDiaryDbSourceImpl(_dao, _logger);

  @preResolve
  Future<Directory> get documentsDirectory =>
      getApplicationDocumentsDirectory();

  @lazySingleton
  LocalDiaryFsDataSource diaryStorage(Directory documentsDirectory) =>
      LocalDiaryFsStorageImpl(
        LocalFileSystemDataSourceImpl(
          baseDirectory: documentsDirectory,
          rootFolder: 'media',
          logger: _logger,
        ),
      );

  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @lazySingleton
  SharedPreferencesDataSource settingsPreferences(
    SharedPreferences sharedPreferences,
  ) =>
      SharedPreferencesDataSourceImpl(sharedPreferences);

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  PasswordSecureStorageDataSource passwordSecureStorage(
    FlutterSecureStorage storage,
  ) =>
      PasswordSecureStorageDataSourceImpl(storage);
}
