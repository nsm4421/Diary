part of '../agenda_tables_repository_impl.dart';

class UserAgendaChoiceDao {
  final db.UserAgendaChoicesTable _userAgendaChoicesTable;

  UserAgendaChoiceDao(this._userAgendaChoicesTable);

  Future<void> insertUserChoice({
    required String agendaId,
    required String agendaChoiceId,
    required String createdBy,
  }) async {
    await _userAgendaChoicesTable.insertRow(
      db.UserAgendaChoicesRow(
        agendaChoiceId: agendaChoiceId,
        agendaId: agendaId,
        createdBy: createdBy,
      ),
    );
  }

  Future<void> upsertUserChoice({
    required String agendaId,
    required String agendaChoiceId,
    required String createdBy,
  }) async {
    await _userAgendaChoicesTable.upsertRow(
      db.UserAgendaChoicesRow(
        agendaChoiceId: agendaChoiceId,
        agendaId: agendaId,
        createdBy: createdBy,
      ),
    );
  }

  Future<void> deleteUserChoice({
    required String agendaId,
    required String createdBy,
  }) async {
    await _userAgendaChoicesTable.delete(
      matchingRows: (q) =>
          q.eq('agendaId', agendaId).eq('created_by', createdBy),
    );
  }
}
