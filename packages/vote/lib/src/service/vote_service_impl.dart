part of 'vote_service.dart';

@LazySingleton(as: VoteService)
class VoteServiceImpl implements VoteService {
  @override
  TaskEither<VoteFailure, AgendaModel> createAgenda({
    required String agendaId,
    required String agendaTitle,
    String? agendaDescription,
    required List<(String, String)> choices,
  }) {
    // TODO: implement createAgenda
    throw UnimplementedError();
  }

  @override
  TaskEither<VoteFailure, AgendaCommentModel> createAgendaComment({
    required String commentId,
    required String agendaId,
    String? parentCommentId,
    required String content,
  }) {
    // TODO: implement createAgendaComment
    throw UnimplementedError();
  }

  @override
  TaskEither<VoteFailure, AgendaReactionModel> createAgendaReaction({
    required String reactionId,
    required String agendaId,
    required VoteReaction reaction,
  }) {
    // TODO: implement createAgendaReaction
    throw UnimplementedError();
  }

  @override
  TaskEither<VoteFailure, void> deleteAgenda(String agendaId) {
    // TODO: implement deleteAgenda
    throw UnimplementedError();
  }

  @override
  TaskEither<VoteFailure, void> deleteAgendaComment(String commentId) {
    // TODO: implement deleteAgendaComment
    throw UnimplementedError();
  }

  @override
  TaskEither<VoteFailure, void> deleteAgendaReaction(String agendaId) {
    // TODO: implement deleteAgendaReaction
    throw UnimplementedError();
  }

  @override
  TaskEither<VoteFailure, List<AgendaFeedModel>> fetchAgendaFeed({
    int offset = 0,
    int limit = 20,
  }) {
    // TODO: implement fetchAgendaFeed
    throw UnimplementedError();
  }

  @override
  TaskEither<VoteFailure, AgendaReactionModel> updateAgendaReaction({
    required String agendaId,
    VoteReaction? reaction,
  }) {
    // TODO: implement updateAgendaReaction
    throw UnimplementedError();
  }
}
