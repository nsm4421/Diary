part of 'vote_service.dart';

@LazySingleton(as: VoteService)
class VoteServiceImpl with DevLoggerMixIn implements VoteService {
  final AgendaTablesRepository _tablesRepository;
  final AgendaRpcRepository _rpcRepository;

  VoteServiceImpl(this._tablesRepository, this._rpcRepository);

  /// agenda & options
  @override
  TaskEither<VoteFailure, AgendaWithChoicesModel> createAgenda({
    required String agendaId,
    required String agendaTitle,
    String? agendaDescription,
    required List<(String, String)> choices,
  }) {
    return TaskEither.tryCatch(
      () async {
        if (choices.length < kMinChoiceCount) {
          throw Exception('선택지는 최소 $kMinChoiceCount개 이상 사용해야 합니다');
        } else if (choices.length > kMaxChoiceCount) {
          throw Exception('선택지는 최대 $kMaxChoiceCount개 이상 사용해야 합니다');
        }

        return await _rpcRepository.createAgendaWithChoices(
          agendaId: agendaId,
          agendaTitle: agendaTitle,
          agendaDescription: agendaDescription,
          choices: choices,
        );
      },
      (error, stackTrace) {
        final message = 'create agenda failed';
        logE(message, error, stackTrace);
        return VoteFailure(
          message: message,
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  @override
  TaskEither<VoteFailure, void> deleteAgenda(String agendaId) {
    return TaskEither.tryCatch(
      () async {
        await _tablesRepository.deleteAgendaById(agendaId);
      },
      (error, stackTrace) {
        final message = 'delete agenda failed';
        logE(message, error, stackTrace);
        return VoteFailure(
          message: message,
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  @override
  TaskEither<VoteFailure, List<AgendaFeedModel>> fetchAgendaFeed({
    required FetchAgendaFeedCursor cursor,
    int limit = 20,
  }) {
    return TaskEither.tryCatch(
      () async {
        return await _tablesRepository
            .fetchAgendaFeed(
              lastAgendaId: cursor.lastAgendaId,
              lastCreatedAt: cursor.lastCreatedAt,
              limit: limit,
            )
            .then((res) => res.toList(growable: false));
      },
      (error, stackTrace) {
        final message = 'fetch agendas failed';
        logE(message, error, stackTrace);
        return VoteFailure(
          message: message,
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  @override
  TaskEither<VoteFailure, AgendaDetailModel> getAgendaDetail(String agendaId) {
    return TaskEither.tryCatch(
      () async {
        return await _rpcRepository.getAgendaDetail(agendaId);
      },
      (error, stackTrace) {
        final message = 'get agenda detail failed';
        logE(message, error, stackTrace);
        return VoteFailure(
          message: message,
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  /// reaction
  @override
  TaskEither<VoteFailure, void> createAgendaReaction({
    required String agendaId,
    required VoteReaction reaction,
  }) {
    return TaskEither.tryCatch(
      () async {
        logD('[VoteServiceImpl]create agenda reaction called');
        await _tablesRepository.insertReaction(
          agendaId: agendaId,
          reaction: reaction,
        );
      },
      (error, stackTrace) {
        final message = 'create reaction failed';
        logE(message, error, stackTrace);
        return VoteFailure(
          message: message,
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  @override
  TaskEither<VoteFailure, void> updateAgendaReaction({
    required String agendaId,
    required VoteReaction reaction,
    required String userId,
  }) {
    return TaskEither.tryCatch(
      () async {
        await _tablesRepository.updateReaction(
          agendaId: agendaId,
          reaction: reaction,
          createdBy: userId,
        );
      },
      (error, stackTrace) {
        final message = 'update reaction failed';
        logE(message, error, stackTrace);
        return VoteFailure(
          message: message,
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  @override
  TaskEither<VoteFailure, void> deleteAgendaReaction({
    required String agendaId,
    required String userId,
  }) {
    return TaskEither.tryCatch(
      () async {
        await _tablesRepository.deleteReaction(
          agendaId: agendaId,
          createdBy: userId,
        );
      },
      (error, stackTrace) {
        final message = 'delete reaction failed';
        logE(message, error, stackTrace);
        return VoteFailure(
          message: message,
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  /// comments
  @override
  TaskEither<VoteFailure, void> createAgendaComment({
    required String commentId,
    required String agendaId,
    String? parentCommentId,
    required String content,
  }) {
    return TaskEither.tryCatch(
      () async {
        await _tablesRepository.createAgendaComment(
          commentId: commentId,
          agendaId: agendaId,
          parentCommentId: parentCommentId,
          content: content,
        );
      },
      (error, stackTrace) {
        final message = 'create comment failed';
        logE(message, error, stackTrace);
        return VoteFailure(
          message: message,
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  @override
  TaskEither<VoteFailure, List<AgendaCommentModel>> fetchAgendaComments({
    required FetchAgendaCommentCursor cursor,
    int limit = 20,
  }) {
    return TaskEither.tryCatch(
      () async {
        return await _tablesRepository
            .fetchAgendaComments(
              agendaId: cursor.agendaId,
              parentCommentId: cursor.parentCommentId,
              lastCommentId: cursor.lastCommentId,
              lastCommentCreatedAt: cursor.lastCommentCreatedAt,
              limit: limit,
            )
            .then((res) => res.toList(growable: false));
      },
      (error, stackTrace) {
        final message = 'fetch comment failed';
        logE(message, error, stackTrace);
        return VoteFailure(
          message: message,
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  @override
  TaskEither<VoteFailure, void> deleteAgendaComment(String commentId) {
    return TaskEither.tryCatch(
      () async {
        await _tablesRepository.deleteAgendaCommentById(commentId);
      },
      (error, stackTrace) {
        final message = 'delete comment failed';
        logE(message, error, stackTrace);
        return VoteFailure(
          message: message,
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }
}
