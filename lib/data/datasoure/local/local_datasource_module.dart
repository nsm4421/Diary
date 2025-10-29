import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'database/local_database.dart';
import 'database/local_database_dao.dart';
import 'diary/local_diary_datasource.dart';

@module
abstract class LocalDatasourceModule {
  final _dao = LocalDatabaseDao(LocalDatabase());
  final _logger = Logger();

  @lazySingleton
  LocalDiaryDataSource get diary => LocalDiaryDataSourceImpl(_dao, _logger);
}
