part of 'agenda_option_choice_repository.dart';

@LazySingleton(as: AgendaOptionChoiceRepository)
class AgendaOptionChoiceRepositoryImpl implements AgendaOptionChoiceRepository {
  final AgendaOptionChoicesTable _dao;
  late final String _clientId;

  AgendaOptionChoiceRepositoryImpl(this._dao, SupabaseClient _client) {
    _clientId = _client.auth.clientId;
  }

  @override
  Future<AgendaOptionChoicesRow?> findClientChoice(String agendaId) async {
    return _dao.querySingleRow(
      queryFn: (q) => q.eq('agenda_id', agendaId).eq('created_by', _clientId),
    );
  }

  @override
  Future<AgendaOptionChoicesRow> insertRow({
    required String agendaId,
    required String optionId,
  }) async {
    return _dao.insertRow(
      AgendaOptionChoicesRow(
        agendaId: agendaId,
        agendaOptionId: optionId,
        createdBy: _clientId,
      ),
    );
  }

  @override
  Future<void> deleteRow(String agendaId) async {
    await _dao.delete(
      matchingRows: (q) =>
          q.eq('agenda_id', agendaId).eq('created_by', _clientId),
    );
  }

  @override
  Future<AgendaOptionChoicesRow> updateRow({
    required String agendaId,
    required String previousOptionId,
    required String currentOptionId,
  }) async {
    return await _dao
        .update(
          matchingRows: (q) => q
              .eq('agenda_id', agendaId)
              .eq('option_id', previousOptionId)
              .eq('created_by', _clientId),
          data: {'option_id': currentOptionId},
        )
        .then((res) => res.first);
  }
}
