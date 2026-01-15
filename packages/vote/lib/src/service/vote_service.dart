import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../core/value_object/vote_failure.dart';
import '../model/agenda_comment/agenda_comment_model.dart';
import '../model/agenda_feed/agenda_feed_model.dart';
import '../model/agenda/agenda_model.dart';
import '../model/agenda_reaction/agenda_reaction_model.dart';

part 'vote_service_impl.dart';

abstract interface class VoteService {
  /// agenda & options
  TaskEither<VoteFailure, AgendaModel> createAgenda({
    required String agendaId,
    required String agendaTitle,
    String? agendaDescription,
    required List<(String id, String label)> choices,
  });

  TaskEither<VoteFailure, void> deleteAgenda(String agendaId);

  TaskEither<VoteFailure, List<AgendaFeedModel>> fetchAgendaFeed({
    int offset = 0,
    int limit = 20,
  });

  /// reaction
  TaskEither<VoteFailure, AgendaReactionModel> createAgendaReaction({
    required String reactionId,
    required String agendaId,
    required VoteReaction reaction,
  });

  TaskEither<VoteFailure, AgendaReactionModel> updateAgendaReaction({
    required String agendaId,
    VoteReaction? reaction,
  });

  TaskEither<VoteFailure, void> deleteAgendaReaction(String agendaId);

  /// comments
  TaskEither<VoteFailure, void> createAgendaComment({
    required String commentId,
    required String agendaId,
    String? parentCommentId,
    required String content,
  });

  TaskEither<VoteFailure, void> deleteAgendaComment(String commentId);
}
