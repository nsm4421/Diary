import 'package:injectable/injectable.dart';
import 'package:vote/vote.dart';
import 'package:shared/shared.dart';
import 'mapper.dart';
import '../../../generated/database.dart';

@LazySingleton(as: AgendaTableRepository)
class AgendaTableRepositoryImpl
    with DevLoggerMixIn
    implements AgendaTableRepository {
  final AgendasTable _dao;

  AgendaTableRepositoryImpl(this._dao);

  @override
  Future<AgendaModel> insert({
    required String id,
    required String title,
    String? description,
  }) async {
    try {
      return await _dao
          .insertRow(AgendasRow(id: id, title: title, description: description))
          .then((row) => row.toModel());
    } catch (error, stackTrace) {
      logE('insert fails', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<AgendaModel> update({
    required String id,
    String? title,
    String? description,
  }) async {
    try {
      final data = {
        if (title != null) 'title': title,
        if (description != null) 'description': description,
      };
      return await _dao
          .update(matchingRows: (q) => q.eq('id', id), data: data)
          .then((row) => row.first.toModel());
    } catch (error, stackTrace) {
      logE('update fails', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _dao.delete(matchingRows: (q) => q.eq('id', id));
    } catch (error, stackTrace) {
      logE('delete fails', error, stackTrace);
      rethrow;
    }
  }
}
