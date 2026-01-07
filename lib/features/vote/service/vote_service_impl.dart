part of 'vote_service.dart';

class VoteServiceImpl implements VoteService {
  final AgendaRepository _agendaRepository;
  final AgendaOptionRepository _optionRepository;
  final Logger _logger;

  VoteServiceImpl(this._agendaRepository, this._optionRepository, this._logger);

  @override
  TaskEither<VoteFailure, AgendaModel> createAgenda({
    required String title,
    required Iterable<String> optionContents,
  }) {
    return TaskEither.tryCatch(
      () async {
        final agenda = await _agendaRepository
            .insert(title: title)
            .then(AgendaModel.fromRow);
        final options = await _optionRepository
            .insertRows(agendaId: agenda.id, contents: optionContents)
            .then(
              (rows) =>
                  rows.map((row) => AgendaOptionModel.fromRow(row)).toList(),
            );
        return agenda.copyWith(options: options);
      },
      (error, stackTrace) {
        return VoteFailure(
          message: 'create agenda fails',
          error: error,
          stackTrace: stackTrace,
          logger: _logger,
        );
      },
    );
  }

  @override
  TaskEither<VoteFailure, Iterable<AgendaModel>> fetchAgendas({
    DateTime? lastCreatedAt,
    int limit = 20,
  }) {
    return TaskEither.tryCatch(
      () async {
        return await _agendaRepository
            .fetch(lastCreatedAt: lastCreatedAt, limit: limit)
            .then((rows) => rows.map(AgendaModel.fromRow));
      },
      (error, stackTrace) {
        return VoteFailure(
          message: 'fetch agenda fails',
          error: error,
          stackTrace: stackTrace,
          logger: _logger,
        );
      },
    );
  }

  @override
  TaskEither<VoteFailure, AgendaModel> getAgendaDetail(String agendaId) {
    return TaskEither.tryCatch(
      () async {
        final agenda = await _agendaRepository.findById(agendaId).then((row) {
          if (row == null) {
            throw Exception('agenda not founded');
          }
          return AgendaModel.fromRow(row);
        });
        final options = await _optionRepository
            .fetchByAgendaId(agendaId)
            .then(
              (rows) =>
                  rows.map((row) => AgendaOptionModel.fromRow(row)).toList(),
            );
        if (options.isEmpty) {
          throw Exception('agenda option is empty');
        }
        return agenda.copyWith(options: options);
      },
      (error, stackTrace) {
        return VoteFailure(
          message: 'get agenda fails',
          error: error,
          stackTrace: stackTrace,
          logger: _logger,
        );
      },
    );
  }

  @override
  TaskEither<VoteFailure, void> deleteAgenda(String agendaId) {
    return TaskEither.tryCatch(
      () async {
        await _agendaRepository.delete(agendaId);
      },
      (error, stackTrace) {
        return VoteFailure(
          message: 'delete agenda fails',
          error: error,
          stackTrace: stackTrace,
          logger: _logger,
        );
      },
    );
  }
}
