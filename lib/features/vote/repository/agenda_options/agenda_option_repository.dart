import 'package:diary/core/core.dart';

part 'agenda_option_repository_impl.dart';

abstract interface class AgendaOptionRepository {
  Future<Iterable<AgendaOptionsRow>> insertRows({
    required String agendaId,
    required Iterable<String> contents,
  });

  Future<Iterable<AgendaOptionsRow>> fetchByAgendaId(String agendaId);

  Future<void> delete(String id);
}
