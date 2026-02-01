part of '../agenda_tables_repository_impl.dart';

class AgendaReactionDao {
  final db.AgendaReactionsTable _agendaReactionsTable;

  AgendaReactionDao(this._agendaReactionsTable);

  Future<void> insertReaction({
    required String agendaId,
    required VoteReaction reaction,
  }) async {
    await _agendaReactionsTable.insertRow(
      db.AgendaReactionsRow(
        agendaId: agendaId,
        reaction: switch (reaction) {
          VoteReaction.like => db.VoteReaction.like,
          VoteReaction.dislike => db.VoteReaction.dislike,
        },
      ),
    );
  }

  Future<void> updateReaction({
    required String agendaId,
    required VoteReaction reaction,
    required String createdBy,
  }) async {
    await _agendaReactionsTable.update(
      matchingRows: (q) =>
          q.eq('agenda_id', agendaId).eq('created_by', createdBy),
      data: {'reaction': reaction.name},
    );
  }

  Future<void> deleteReaction({
    required String agendaId,
    required String createdBy,
  }) async {
    await _agendaReactionsTable.delete(
      matchingRows: (q) =>
          q.eq('agenda_id', agendaId).eq('created_by', createdBy),
    );
  }
}
