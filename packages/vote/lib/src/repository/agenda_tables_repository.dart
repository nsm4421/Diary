import 'package:vote/src/model/agenda_comment/agenda_comment_model.dart';

import '../model/agenda_feed/agenda_feed_model.dart';
import '../model/agenda_reaction/agenda_reaction_model.dart';

abstract interface class AgendaTablesRepository {
  /// agenda & choice
  Future<Iterable<AgendaFeedModel>> fetchAgendaFeed({
    String? lastAgendaId,
    DateTime? lastCreatedAt,
    int limit = 20
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
  Future<Iterable<AgendaCommentModel>> fetchAgendaComments({
    required String agendaId,
    String? parentCommentId,
    String? lastCommentId,
    DateTime? lastCommentCreatedAt,
    int limit = 20
  });

  Future<void> createAgendaComment({
    required String commentId,
    required String agendaId,
    String? parentCommentId,
    required String content,
  });

  Future<void> deleteAgendaCommentById(String commentId);
}
