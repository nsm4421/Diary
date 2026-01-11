part of 'agenda_repository.dart';

@LazySingleton(as: AgendaRepository)
class AgendaRepositoryImpl implements AgendaRepository {
  final AgendasTable _dao;
  late final String _clientId;

  AgendaRepositoryImpl(this._dao, SupabaseClient _client) {
    _clientId = _client.auth.clientId;
  }

  @override
  Future<AgendasRow> insert({
    String? id,
    required String title,
    String? description,
  }) async {
    return await _dao.insertRow(
      AgendasRow(
        id: id,
        title: title,
        description: description,
        createdBy: _clientId,
      ),
    );
  }

  @override
  Future<AgendasRow?> findById(String id) async {
    return await _dao.querySingleRow(queryFn: (q) => q.eq('id', id));
  }

  @override
  Future<AgendasRow> update({required String id, required String title}) async {
    return await _dao.upsertRow(
      AgendasRow(id: id, title: title, createdBy: _clientId),
    );
  }

  @override
  Future<Iterable<AgendasRow>> fetch({
    DateTime? lastCreatedAt,
    int limit = 20,
  }) async {
    final cursor = (lastCreatedAt ?? DateTime.now().toUtc()).toIso8601String();
    return await _dao.queryRows(
      queryFn: (q) => q.lt('created_at', cursor).order('created_at'),
      limit: limit,
    );
  }

  @override
  Future<void> delete(String id) async {
    await _dao.delete(matchingRows: (q) => q.eq('id', id));
  }
}
