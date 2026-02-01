import 'package:diary/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:shared/shared.dart';
import 'package:vote/vote.dart';

part 'state.dart';

part 'event.dart';

part 'bloc.freezed.dart';

@injectable
class AgendaDetailBloc extends Bloc<AgendaDetailEvent, AgendaDetailState> {
  final String _agendaId;
  final VoteService _voteService;
  final Logger _logger;

  AgendaDetailBloc(
    @factoryParam this._agendaId,
    this._voteService,
    this._logger,
  ) : super(AgendaDetailState.idle()) {
    on<_StartedEvent>(_onStart);
    on<_ChoiceSeletedEvent>(_onChoice);
    on<_CommentUpdatedEvent>(_onCommentUpdated);
  }

  Future<void> _onStart(
    _StartedEvent event,
    Emitter<AgendaDetailState> emit,
  ) async {
    emit(AgendaDetailState.initializing());
    (await _voteService.getAgendaDetail(_agendaId).run()).match(
      (failure) {
        _logger.failure(failure);
        emit(AgendaDetailState.idle(failure: failure));
      },
      (data) {
        _logger.t('agenda fetched:${data.id}');
        final userChoiceId = data.myChoiceId;
        emit(
          userChoiceId == null
              ? AgendaDetailState.choiceUnSelected(agenda: data)
              : AgendaDetailState.choiceSelected(
                  agenda: data,
                  userChoiceId: userChoiceId,
                ),
        );
      },
    );
  }

  Future<void> _onChoice(
    _ChoiceSeletedEvent event,
    Emitter<AgendaDetailState> emit,
  ) async {
    final temp = state.agenda;
    if (temp == null) return;
    emit(AgendaDetailState.loading(agenda: temp));
    (await _voteService
            .createUserChoice(
              agendaId: temp.id,
              agendaChoiceId: event.userChoiceId,
              userId: event.userId,
            )
            .run())
        .match(
          (failure) {
            final myChoiceId = temp.myChoiceId;
            _logger.failure(failure);
            emit(
              myChoiceId == null
                  ? AgendaDetailState.choiceUnSelected(
                      agenda: temp,
                      failure: failure,
                    )
                  : AgendaDetailState.choiceSelected(
                      agenda: temp,
                      userChoiceId: myChoiceId,
                      failure: failure,
                    ),
            );
          },
          (_) {
            emit(
              AgendaDetailState.choiceSelected(
                agenda: temp.copyWith(
                  myChoiceId: event.userChoiceId,
                  choices: temp.choices.map(
                    (choice) => choice.id == event.userChoiceId
                        ? choice.copyWith(voteCount: choice.voteCount + 1)
                        : choice,
                  ).toList(growable: false),
                ),
                userChoiceId: event.userChoiceId,
              ),
            );
          },
        );
  }

  Future<void> _onCommentUpdated(
    _CommentUpdatedEvent event,
    Emitter<AgendaDetailState> emit,
  ) async {
    final myChoiceId = state.agenda?.myChoiceId;
    final agenda = state.agenda?.copyWith(
      commentCount: (state.agenda?.commentCount ?? 0) + event.commentCountDelta,
      latestComment: event.lastestCommentContent ?? state.agenda?.latestComment,
    );
    if (agenda == null) return;
    emit(
      myChoiceId == null
          ? AgendaDetailState.choiceUnSelected(agenda: agenda)
          : AgendaDetailState.choiceSelected(
              agenda: agenda,
              userChoiceId: myChoiceId,
            ),
    );
  }
}
