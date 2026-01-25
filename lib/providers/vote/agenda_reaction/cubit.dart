import 'package:diary/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:vote/vote.dart';

part 'state.dart';

part 'cubit.freezed.dart';

@injectable
class VoteReactionCubit extends Cubit<VoteReactonState> {
  late final String _agendaId;
  final VoteService _voteService;
  final Logger _logger;

  VoteReactionCubit(
    @factoryParam VoteReactionParams params,
    this._voteService,
    this._logger,
  ) : super(
        VoteReactonState(
          reaction: params.myReaction,
          likeCount: params.likeCount,
          dislikeCount: params.dislikeCount,
        ),
      ) {
    _agendaId = params.agendaId;
  }

  Future<void> handleReaction({
    required VoteReaction tapped,
    required String currentUid,
  }) async {
    try {
      if (state.status.isLoading) return;
      emit(state.copyWith(status: Status.loading));

      if (state.reaction == null) {
        _logger.t(
          'create reaction called|current${state.reaction},tapped:$tapped',
        );

        // Insert
        await (_voteService
                .createAgendaReaction(agendaId: _agendaId, reaction: tapped)
                .run())
            .then(
              (res) => res.match(
                (failure) {
                  _logger.failure(failure);
                  _resetState();
                },
                (_) {
                  _logger.t('insert reaction success');
                  emit(
                    state.copyWith(
                      status: Status.initial,
                      reaction: tapped,
                      likeCount: tapped == VoteReaction.like
                          ? state.likeCount + 1
                          : state.likeCount,
                      dislikeCount: tapped == VoteReaction.dislike
                          ? state.dislikeCount + 1
                          : state.dislikeCount,
                    ),
                  );
                },
              ),
            );
      } else if (state.reaction == tapped) {
        _logger.t(
          'clear reaction called|current${state.reaction},tapped:$tapped',
        );

        // Delete
        await (_voteService
                .deleteAgendaReaction(agendaId: _agendaId, userId: currentUid)
                .run())
            .then(
              (res) => res.match(
                (failure) {
                  _logger.failure(failure);
                  _resetState();
                },
                (_) {
                  _logger.t('delete reaction success');
                  emit(
                    state.copyWith(
                      status: Status.initial,
                      reaction: null,
                      likeCount: tapped == VoteReaction.like
                          ? state.likeCount - 1
                          : state.likeCount,
                      dislikeCount: tapped == VoteReaction.dislike
                          ? state.dislikeCount - 1
                          : state.dislikeCount,
                    ),
                  );
                },
              ),
            );
      } else if (state.reaction != tapped) {
        _logger.t(
          'update reaction called|current${state.reaction},tapped:$tapped',
        );
        // Update
        await (_voteService
                .updateAgendaReaction(
                  agendaId: _agendaId,
                  reaction: tapped,
                  userId: currentUid,
                )
                .run())
            .then(
              (res) => res.match(
                (failure) {
                  _logger.failure(failure);
                  _resetState();
                },
                (_) {
                  _logger.t('update reaction success');
                  emit(
                    state.copyWith(
                      status: Status.initial,
                      reaction: tapped,
                      likeCount: tapped == VoteReaction.like
                          ? state.likeCount + 1
                          : state.likeCount - 1,
                      dislikeCount: tapped == VoteReaction.dislike
                          ? state.dislikeCount + 1
                          : state.dislikeCount - 1,
                    ),
                  );
                },
              ),
            );
      }
    } catch (error, stackTrace) {
      _resetState();
      _logger.e('handle emotion fails', error: error, stackTrace: stackTrace);
    }
  }

  void _resetState() {
    emit(state.copyWith(status: Status.initial));
  }
}
