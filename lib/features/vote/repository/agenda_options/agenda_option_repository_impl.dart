part of 'agenda_option_repository.dart';

@LazySingleton(as: AgendaOptionRepository)
class AgendaOptionRepositoryImpl implements AgendaOptionRepository {
  final AgendaOptionsTable _dao;

  AgendaOptionRepositoryImpl(this._dao);

  @override
  Future<Iterable<AgendaOptionsRow>> insertRows({
    required String agendaId,
    required Iterable<String> contents,
  }) async {
    final futures = contents.toList().asMap().entries.map(
      (e) => _dao.insertRow(
        AgendaOptionsRow(agendaId: agendaId, sequence: e.key, content: e.value),
      ),
    );
    return await Future.wait(futures);
  }

  @override
  Future<Iterable<AgendaOptionsRow>> fetchByAgendaId(String agendaId) async {
    return _dao.queryRows(
      queryFn: (q) =>
          q.eq('agenda_id', agendaId).order('sequence', ascending: true),
    );
  }

  @override
  Future<void> delete(String agendaId) async {
    await _dao.delete(matchingRows: (q) => q.eq('agenda_id', agendaId));
  }
}
