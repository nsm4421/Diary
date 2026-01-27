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
  ) : super(AgendaDetailState()) {
    on<_FetchEvent>(_onFetch);
  }

  Future<void> _onFetch(
    _FetchEvent event,
    Emitter<AgendaDetailState> emit,
  ) async {
    (await _voteService.getAgendaDetail(_agendaId).run()).match(
      (failure) {
        _logger.failure(failure);
        emit(state.copyWith(status: Status.error, failure: failure));
      },
      (agendaDetail) {
        emit(
          state.copyWith(
            status: Status.initial,
            failure: null,
            agenda: agendaDetail,
          ),
        );
      },
    );
  }
}
