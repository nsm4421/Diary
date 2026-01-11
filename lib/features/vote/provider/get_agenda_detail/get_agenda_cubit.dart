import 'package:diary/core/core.dart';
import 'package:fpdart/src/task_either.dart';

import '../../model/agenda_model.dart';
import '../../service/vote_service.dart';

class GetAgendaDetailCubit extends GetDataCubit<AgendaModel> {
  final VoteService _service;

  GetAgendaDetailCubit(this._service);

  @override
  TaskEither<Failure, AgendaModel> callApi(String id) =>
      _service.getAgendaDetail(id);
}
