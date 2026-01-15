import 'package:injectable/injectable.dart';
import 'package:vote/vote.dart';
import 'package:shared/shared.dart';
import '../../../generated/database.dart' as db;
import 'mapper.dart';

@LazySingleton(as: AgendaTablesRepository)
class AgendaTablesRepositoryImpl
    with DevLoggerMixIn
    implements AgendaTablesRepository {
  final db.AgendasTable _agendasTable;
  final db.AgendaCommentsTable _agendaCommentsTable;
  final db.AgendaReactionsTable _agendaReactionsTable;
  final db.AgendaFeedTable _agendaFeedTable;

  AgendaTablesRepositoryImpl(
      this._agendasTable,
      this._agendaCommentsTable,
      this._agendaReactionsTable,
      this._agendaFeedTable,
      );

  @override
  Future<void> deleteAgendaById(String agendaId) async {
    try {
      await _agendasTable.delete(matchingRows: (q) => q.eq('id', agendaId));
    } catch (error, stackTrace) {
      logE('delete agenda failed', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<Iterable<AgendaFeedModel>> fetchAgendaFeed({
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      return await _agendaFeedTable
          .queryRows(
        queryFn: (q) => q.order('created_at').range(offset, offset + limit),
        limit: limit,
      )
          .then((res) => res.map((e) => e.toModel()));
    } catch (error, stackTrace) {
      logE('fetch agenda feeds failed', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> insertReaction({
    required String reactionId,
    required String agendaId,
    required VoteReaction reaction,
  }) async {
    try {
      await _agendaReactionsTable.insertRow(
        db.AgendaReactionsRow(
          id: reactionId,
          agendaId: agendaId,
          reaction: reaction.dto,
        ),
      );
    } catch (error, stackTrace) {
      logE('create agenda reaction failed', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> updateReaction({
    required String reactionId,
    required String agendaId,
    required VoteReaction reaction,
  }) async {
    try {
      await _agendaReactionsTable.upsertRow(
        db.AgendaReactionsRow(
          id: reactionId,
          agendaId: agendaId,
          reaction: reaction.dto,
        ),
      );
    } catch (error, stackTrace) {
      logE('update reaction failed', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteReactionById(String reactionId) async {
    try {
      await _agendaReactionsTable.delete(
        matchingRows: (q) => q.eq('id', reactionId),
      );
    } catch (error, stackTrace) {
      logE('delete comment failed', error, stackTrace);
      rethrow;
    }
  }

  /// comments
  @override
  Future<void> createAgendaComment({
    required String commentId,
    required String agendaId,
    String? parentCommentId,
    required String content,
  }) async {
    try {
      await _agendaCommentsTable.insertRow(
        db.AgendaCommentsRow(
          id: commentId,
          agendaId: agendaId,
          content: content,
          parentId: parentCommentId,
        ),
      );
    } catch (error, stackTrace) {
      logE('create comment failed', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteAgendaCommentById(String commentId) async {
    try {
      await _agendaCommentsTable.delete(
        matchingRows: (q) => q.eq('id', commentId),
      );
    } catch (error, stackTrace) {
      logE('delete comment failed', error, stackTrace);
      rethrow;
    }
  }
}
