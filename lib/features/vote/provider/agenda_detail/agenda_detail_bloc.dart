import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:diary/core/core.dart';
import 'package:diary/features/vote/service/vote_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../model/agenda_model.dart';

part 'agenda_detail_state.dart';

part 'agenda_detail_event.dart';

part 'agenda_detail_bloc.freezed.dart';

@injectable
class AgendaDetailBloc extends Bloc<AgendaDetailEvent, AgendaDetailState> {
  final String _agendaId;
  final VoteService _service;

  AgendaDetailBloc(@factoryParam this._agendaId, this._service)
    : super(AgendaDetailState.idle(_agendaId)) {
    on<_Started>(_onStarted, transformer: restartable());
    on<_Voted>(_onVote, transformer: droppable());
  }

  Future<void> _onStarted(
    _Started event,
    Emitter<AgendaDetailState> emit,
  ) async {
    if (state.mounted && state.data != null) return;
    (await _service.getAgendaDetail(_agendaId).run()).match(
      (failure) {
        emit(_FailFetching(agendaId: _agendaId, failure: failure));
      },
      (data) {
        emit(_Fetched(data));
      },
    );
  }

  Future<void> _onVote(_Voted event, Emitter<AgendaDetailState> emit) async {
    if (!state.mounted || state.data == null) return;
    final temp = state.data!;

    final previousOptionId = state.data?.options
        .where((e) => e.choiceByMe)
        .firstOrNull
        ?.id;
    final currentOptionId = event.optionId;
    if (previousOptionId == currentOptionId) return;

    emit(_Loading(temp));
    (await _service
            .voteOnAgenda(
              agendaId: _agendaId,
              previousOptionId: previousOptionId,
              currentOptionId: currentOptionId,
            )
            .run())
        .match((failure) => emit(_Failure(agenda: temp, failure: failure)), (
          data,
        ) {
          emit(
            _Fetched(
              temp.copyWith(
                options: temp.options
                    .map((o) {
                      if (o.id == previousOptionId) {
                        return o.copyWith(
                          choiceByMe: false,
                          choiceCount: o.choiceCount - 1,
                        );
                      } else if (o.id == currentOptionId) {
                        return o.copyWith(
                          choiceByMe: true,
                          choiceCount: o.choiceCount + 1,
                        );
                      }
                      return o;
                    })
                    .toList(growable: false),
              ),
            ),
          );
        });
  }
}
