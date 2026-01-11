import 'package:diary/core/core.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../model/agenda_model.dart';
import '../../service/vote_service.dart';

@injectable
class DisplayAgendasBloc extends DisplayBlocWithDateTimeCursor<AgendaModel> {
  final VoteService _service;

  DisplayAgendasBloc(this._service);

  @override
  TaskEither<Failure, List<AgendaModel>> fetch({
    required DateTime cursor,
    int limit = 20,
  }) => _service.fetchAgendas(lastCreatedAt: cursor, limit: limit);
}
