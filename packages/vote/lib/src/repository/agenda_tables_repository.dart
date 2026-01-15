import 'package:vote/src/model/agenda_comment/agenda_comment_model.dart';
import 'package:vote/src/model/agenda_feed/agenda_feed_model.dart';
import '../model/agenda_reaction/agenda_reaction_model.dart';

abstract interface class AgendaTablesRepository {
  /// agenda & choice
  // TODO : 커서 페이징 처리
  Future<Iterable<AgendaFeedModel>> fetchAgendaFeed({
    int offset = 0,
    int limit = 20,
  });

  Future<void> deleteAgendaById(String agendaId);

  /// reaction
  Future<void> insertReaction({
    required String reactionId,
    required String agendaId,
    required VoteReaction reaction,
  });

  Future<void> updateReaction({
    required String reactionId,
    required String agendaId,
    required VoteReaction reaction,
  });

  Future<void> deleteReactionById(String reactionId);

  /// comments
  // TODO : 댓글 목록 조회 기능
  Future<void> createAgendaComment({
    required String commentId,
    required String agendaId,
    String? parentCommentId,
    required String content,
  });

  Future<void> deleteAgendaCommentById(String commentId);
}
