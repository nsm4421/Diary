import 'package:vote/src/model/agenda_comment/agenda_comment_model.dart';

import '../model/agenda_feed/agenda_feed_model.dart';
import '../model/agenda_reaction/agenda_reaction_model.dart';

abstract interface class AgendaTablesRepository {
  /// agenda
  Future<Iterable<AgendaFeedModel>> fetchAgendaFeed({
    String? lastAgendaId,
    DateTime? lastCreatedAt,
    int limit = 20,
  });

  Future<void> deleteAgendaById(String agendaId);

  /// choices
  Future<void> insertUserChoice({
    required String agendaId,
    required String agendaChoiceId,
    required String createdBy,
  });

  Future<void> upsertUserChoice({
    required String agendaId,
    required String agendaChoiceId,
    required String createdBy,
  });

  Future<void> deleteUserChoice({
    required String agendaId,
    required String createdBy,
  });

  /// reaction
  Future<void> insertReaction({
    required String agendaId,
    required VoteReaction reaction,
  });

  Future<void> updateReaction({
    required String agendaId,
    required VoteReaction reaction,
    required String createdBy,
  });

  Future<void> deleteReaction({
    required String agendaId,
    required String createdBy,
  });

  /// comments
  Future<Iterable<AgendaCommentModel>> fetchAgendaComments({
    required String agendaId,
    String? parentCommentId,
    String? lastCommentId,
    DateTime? lastCommentCreatedAt,
    int limit = 20,
  });

  Future<void> createAgendaComment({
    required String commentId,
    required String agendaId,
    String? parentCommentId,
    required String content,
  });

  Future<void> deleteAgendaCommentById(String commentId);
}
