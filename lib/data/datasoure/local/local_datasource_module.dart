import 'dart:io';

import 'package:diary/data/datasoure/local/diary/local_diary_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'database/local_database.dart';
import 'database/local_database_dao.dart';
import 'diary/local_diary_datasource.dart';
import 'storage/local_storage_datasource.dart';

@module
abstract class LocalDatasourceModule {
  final _dao = LocalDatabaseDao(LocalDatabase());
  final _logger = Logger();

  @lazySingleton
  LocalDiaryDataSource get diary => LocalDiaryDataSourceImpl(_dao, _logger);

  @preResolve
  Future<Directory> get documentsDirectory =>
      getApplicationDocumentsDirectory();

  @lazySingleton
  LocalDiaryStorage diaryStorage(Directory documentsDirectory) =>
      LocalDiaryStorageImpl(
        LocalStorageDataSourceImpl(
          baseDirectory: documentsDirectory,
          rootFolder: 'media',
          logger: _logger,
        ),
      );
}
