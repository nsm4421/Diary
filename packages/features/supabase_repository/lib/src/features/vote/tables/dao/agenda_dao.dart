part of '../agenda_tables_repository_impl.dart';

class AgendaDao {
  final db.AgendasTable _table;

  AgendaDao(this._table);

  Future<void> deleteAgendaById(String agendaId) async {
    await _table.delete(matchingRows: (q) => q.eq('id', agendaId));
  }
}

