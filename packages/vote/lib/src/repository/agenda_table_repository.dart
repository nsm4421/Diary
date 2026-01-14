import '../model/agenda/agenda_model.dart';

abstract interface class AgendaTableRepository {
  Future<AgendaModel> insert({
    required String id,
    required String title,
    String? description,
  });

  Future<AgendaModel> update({
    required String id,
    String? title,
    String? description,
  });

  Future<void> delete(String id);
}
