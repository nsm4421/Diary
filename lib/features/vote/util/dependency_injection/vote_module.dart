import 'package:diary/core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../provider/create_agenda/create_agenda_bloc.dart';
import '../../provider/display_agendas/display_agendas_bloc.dart';
import '../../repository/agendas/agenda_repository.dart';
import '../../repository/agenda_options/agenda_option_repository.dart';
import '../../service/vote_service.dart';

@module
abstract class VoteModule {
  final _logger = Logger();

  @lazySingleton
  String get _clientId => Supabase.instance.client.auth.clientId;

  @lazySingleton
  AgendaRepository get _agendaRepository =>
      AgendaRepositoryImpl(AgendasTable(), _clientId);

  @lazySingleton
  AgendaOptionRepository get _agendaOptionRepository =>
      AgendaOptionRepositoryImpl(AgendaOptionsTable(), _clientId);

  @lazySingleton
  VoteService get _voteService =>
      VoteServiceImpl(_agendaRepository, _agendaOptionRepository, _logger);

  @injectable
  DisplayAgendasBloc get displayAgendasBloc => DisplayAgendasBloc(_voteService);

  @injectable
  CreateAgendaBloc get createAgendaBloc =>
      CreateAgendaBloc(_voteService, _logger);
}
