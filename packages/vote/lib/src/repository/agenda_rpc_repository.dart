import '../model/agenda/agenda_with_choices_model.dart';

abstract interface class AgendaRpcRepository {
  Future<AgendaWithChoicesModel> createAgendaWithChoices({
    required String agendaId,
    required String agendaTitle,
    String? agendaDescription,
    required List<(String choiceId, String label)> choices,
  });
}
