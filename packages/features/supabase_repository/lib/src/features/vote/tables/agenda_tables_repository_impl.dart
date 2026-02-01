import 'package:injectable/injectable.dart';
import 'package:vote/vote.dart';
import 'package:shared/shared.dart';
import '../../../generated/database.dart' as db;

part 'dao/agenda_dao.dart';

part 'dao/agenda_comment_dao.dart';

part 'dao/agenda_comment_feed_dao.dart';

part 'dao/agenda_feed_dao.dart';

part 'dao/user_agenda_choice_dao.dart';

part 'dao/agenda_reaction_dao.dart';

@LazySingleton(as: AgendaTablesRepository)
class AgendaTablesRepositoryImpl
    with DevLoggerMixIn
    implements AgendaTablesRepository {
  final AgendaDao _agendaDao;
  final AgendaFeedDao _agendaFeedDao;
  final AgendaCommentDao _commentDao;
  final AgendaCommentFeedDao _commentFeedDao;
  final AgendaReactionDao _reactionDao;
  final UserAgendaChoiceDao _userChoiceDao;

  AgendaTablesRepositoryImpl(
    this._agendaDao,
    this._agendaFeedDao,
    this._commentDao,
    this._commentFeedDao,
    this._reactionDao,
    this._userChoiceDao,
  );

  /// agenda
  @override
  Future<Iterable<AgendaFeedModel>> fetchAgendaFeed({
    String? lastAgendaId,
    DateTime? lastCreatedAt,
    int limit = 20,
  }) async {
    try {
      return await _agendaFeedDao.fetchAgendaFeed(
        lastAgendaId: lastAgendaId,
        lastCreatedAt: lastCreatedAt,
        limit: limit,
      );
    } catch (error, stackTrace) {
      logE('fetch agenda failed', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteAgendaById(String agendaId) async {
    try {
      await _agendaDao.deleteAgendaById(agendaId);
    } catch (error, stackTrace) {
      logE('delete agenda failed', error, stackTrace);
      rethrow;
    }
  }

  /// user choice
  @override
  Future<void> insertUserChoice({
    required String agendaId,
    required String agendaChoiceId,
    required String createdBy,
  }) async {
    try {
      return await _userChoiceDao.insertUserChoice(
        agendaId: agendaId,
        agendaChoiceId: agendaChoiceId,
        createdBy: createdBy,
      );
    } catch (error, stackTrace) {
      logE('insert user choice failed', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> upsertUserChoice({
    required String agendaId,
    required String agendaChoiceId,
    required String createdBy,
  }) async {
    try {
      return await _userChoiceDao.upsertUserChoice(
        agendaId: agendaId,
        agendaChoiceId: agendaChoiceId,
        createdBy: createdBy,
      );
    } catch (error, stackTrace) {
      logE('upsert user choice failed', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteUserChoice({
    required String agendaId,
    required String createdBy,
  }) async {
    try {
      return await _userChoiceDao.deleteUserChoice(
        agendaId: agendaId,
        createdBy: createdBy,
      );
    } catch (error, stackTrace) {
      logE('delete user choice failed', error, stackTrace);
      rethrow;
    }
  }

  /// choice
  @override
  Future<void> insertReaction({
    required String agendaId,
    required VoteReaction reaction,
  }) async {
    try {
      logD(
        '[AgendaTablesRepositoryImpl]insert reaction request|agenda id:$agendaId|reaction:${reaction.name}',
      );
      await _reactionDao.insertReaction(agendaId: agendaId, reaction: reaction);
    } catch (error, stackTrace) {
      logE('create agenda reaction failed', error, stackTrace);
      rethrow;
    }
  }

  /// reaction
  @override
  Future<void> updateReaction({
    required String agendaId,
    required VoteReaction reaction,
    required String createdBy,
  }) async {
    try {
      await _reactionDao.updateReaction(
        agendaId: agendaId,
        reaction: reaction,
        createdBy: createdBy,
      );
    } catch (error, stackTrace) {
      logE('update reaction failed', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteReaction({
    required String agendaId,
    required String createdBy,
  }) async {
    try {
      await _reactionDao.deleteReaction(
        agendaId: agendaId,
        createdBy: createdBy,
      );
    } catch (error, stackTrace) {
      logE('delete reaction failed', error, stackTrace);
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
      await _commentDao.createAgendaComment(
        commentId: commentId,
        agendaId: agendaId,
        content: content,
      );
    } catch (error, stackTrace) {
      logE('create comment failed', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteAgendaCommentById(String commentId) async {
    try {
      await _commentDao.deleteAgendaCommentById(commentId);
    } catch (error, stackTrace) {
      logE('delete comment failed', error, stackTrace);
      rethrow;
    }
  }

  /// comment feed
  @override
  Future<Iterable<AgendaCommentModel>> fetchAgendaComments({
    required String agendaId,
    String? parentCommentId,
    String? lastCommentId,
    DateTime? lastCommentCreatedAt,
    int limit = 20,
  }) async {
    try {
      return await _commentFeedDao.fetchAgendaComments(
        agendaId: agendaId,
        parentCommentId: parentCommentId,
        lastCommentId: lastCommentId,
        lastCommentCreatedAt: lastCommentCreatedAt,
        limit: limit,
      );
    } catch (error, stackTrace) {
      logE('fetch comment failed', error, stackTrace);
      rethrow;
    }
  }
}
