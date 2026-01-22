import 'package:diary/core/core.dart';
import 'package:diary/providers/auth/app_auth/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:vote/vote.dart';

part 'state.dart';

part 'cubit.freezed.dart';

@injectable
class AgendaReactionCubit extends Cubit<AgendaReactionState> {
  final String _agendaId;
  final VoteService _voteService;
  final AuthenticationBloc _authBloc;
  final Logger _logger;
  String? _currentUid;

  AgendaReactionCubit(
    @factoryParam this._agendaId,
    @factoryParam VoteReaction? reaction,
    this._voteService,
    this._authBloc,
    this._logger,
  ) : super(AgendaReactionState.idle()) {
    // TODO : _currentUid 세팅 안되는 버그 수정
    _currentUid = _authBloc.state.currentUser?.id;
    if (_currentUid != null && reaction != null) {
      emit(AgendaReactionState.onReaction(reaction));
    }
  }

  Future<void> addReaction(VoteReaction reaction) async {
    try {
      if (state.isLoading || state.current == reaction || _currentUid == null) {
        return;
      }
      emit(AgendaReactionState.loading(reaction));
      await (_voteService
              .updateAgendaReaction(
                agendaId: _agendaId,
                reaction: reaction,
                userId: _currentUid!,
              )
              .run())
          .then(
            (res) => res.match(
              (failure) {
                _logger.failure(failure);
                _resetState();
              },
              (_) {
                emit(AgendaReactionState.onReaction(reaction));
              },
            ),
          );
    } catch (error, stackTrace) {
      _resetState();
      _logger.e('add emotion fails', error: error, stackTrace: stackTrace);
    }
  }

  Future<void> clearReaction() async {
    final previous = state.current;
    if (state.isLoading || previous == null || _currentUid == null) {
      return;
    }

    try {
      emit(AgendaReactionState.loading(previous));
      await (_voteService
              .deleteAgendaReaction(agendaId: _agendaId, userId: _currentUid!)
              .run())
          .then(
            (res) => res.match(
              (failure) {
                _logger.failure(failure);
                emit(AgendaReactionState.onReaction(previous));
              },
              (_) {
                emit(AgendaReactionState.idle());
              },
            ),
          );
    } catch (error, stackTrace) {
      emit(AgendaReactionState.onReaction(previous));
      _logger.e('add emotion fails', error: error, stackTrace: stackTrace);
    }
  }

  void _resetState() {
    final reaction = state.current;
    emit(
      reaction == null
          ? AgendaReactionState.idle()
          : AgendaReactionState.onReaction(reaction),
    );
  }
}
