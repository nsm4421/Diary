import 'package:diary/features/vote/model/agenda_option_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:diary/core/core.dart';

import '../../model/agenda_model.dart';
import '../../service/vote_service.dart';

part 'create_agenda_data.dart';

part 'create_agenda_bloc.freezed.dart';

class CreateAgendaBloc extends CreateBloc<CreateAgendaData, AgendaModel> {
  late final String _clientAgendaId;
  final Logger _logger;
  final VoteService _service;
  AgendaModel? _created;

  CreateAgendaBloc(this._service, this._logger) : super(CreateAgendaData()) {
    _clientAgendaId = Uuid().v4();
  }

  AgendaModel? get created => state.isSuccess ? _created : null;

  @override
  String? validate(CreateAgendaData data) {
    if (data.title.isEmpty) return 'title can not be empty';
    if (data.options.isEmpty) return 'options can not be empty';
    if (data.options.length != data.options.toSet().length) {
      return 'options duplicated';
    }
    if (data.options.any((text) => text.isEmpty)) {
      return 'option can not be empty';
    }

    return null;
  }

  @override
  void onSuccess(AgendaModel res) {
    _logger.i('create agenda success');
    _created = res;
  }

  @override
  TaskEither<Failure, AgendaModel> submit(CreateAgendaData data) {
    return _service.createAgenda(
      clientAgendaId: _clientAgendaId,
      title: data.title,
      optionContents: data.options,
    );
  }
}
