import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';
import 'package:vote/src/core/value_object/cursor.dart';

import '../core/value_object/constraint.dart';
import '../core/value_object/vote_failure.dart';
import '../repository/agenda_rpc_repository.dart';
import '../repository/agenda_tables_repository.dart';
import '../model/agenda_feed/agenda_feed_model.dart';
import '../model/agenda/agenda_with_choices_model.dart';
import '../model/agenda_reaction/agenda_reaction_model.dart';
import '../model/agenda_comment/agenda_comment_model.dart';

part 'vote_service_impl.dart';

abstract interface class VoteService {
  /// agenda & options
  TaskEither<VoteFailure, AgendaWithChoicesModel> createAgenda({
    required String agendaId,
    required String agendaTitle,
    String? agendaDescription,
    required List<(String id, String label)> choices,
  });

  TaskEither<VoteFailure, void> deleteAgenda(String agendaId);

  TaskEither<VoteFailure, List<AgendaFeedModel>> fetchAgendaFeed({
    required FetchAgendaFeedCursor cursor,
    int limit = 20,
  });

  /// reaction
  TaskEither<VoteFailure, void> createAgendaReaction({
    required String agendaId,
    required VoteReaction reaction,
  });

  TaskEither<VoteFailure, void> updateAgendaReaction({
    required String agendaId,
    required VoteReaction reaction,
    required String userId,
  });

  TaskEither<VoteFailure, void> deleteAgendaReaction({
    required String agendaId,
    required String userId,
  });

  /// comments
  TaskEither<VoteFailure, void> createAgendaComment({
    required String commentId,
    required String agendaId,
    String? parentCommentId,
    required String content,
  });

  TaskEither<VoteFailure, List<AgendaCommentModel>> fetchAgendaComments({
    required FetchAgendaCommentCursor cursor,
    int limit = 20,
  });

  TaskEither<VoteFailure, void> deleteAgendaComment(String commentId);
}
