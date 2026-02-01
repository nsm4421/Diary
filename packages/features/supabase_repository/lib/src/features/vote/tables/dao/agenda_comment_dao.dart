part of '../agenda_tables_repository_impl.dart';

class AgendaCommentDao {
  final db.AgendaCommentsTable _table;

  AgendaCommentDao(this._table);

  Future<void> createAgendaComment({
    required String commentId,
    required String agendaId,
    String? parentCommentId,
    required String content,
  }) async {
    await _table.insertRow(
      db.AgendaCommentsRow(
        id: commentId,
        agendaId: agendaId,
        content: content,
        parentId: parentCommentId,
      ),
    );
  }

  Future<void> deleteAgendaCommentById(String commentId) async {
    await _table.delete(matchingRows: (q) => q.eq('id', commentId));
  }
}
