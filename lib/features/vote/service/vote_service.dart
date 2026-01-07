import 'package:diary/features/vote/model/agenda_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';

import '../model/agenda_option_model.dart';
import '../repository/agenda_options/agenda_option_repository.dart';
import '../repository/agendas/agenda_repository.dart';
import 'vote_failure.dart';

part 'vote_service_impl.dart';

abstract interface class VoteService {
  TaskEither<VoteFailure, AgendaModel> createAgenda({
    required String title,
    required Iterable<String> optionContents,
  });

  TaskEither<VoteFailure, Iterable<AgendaModel>> fetchAgendas({
    DateTime? lastCreatedAt,
    int limit = 20,
  });

  TaskEither<VoteFailure, AgendaModel> getAgendaDetail(String agendaId);

  TaskEither<VoteFailure, void> deleteAgenda(String agendaId);
}
