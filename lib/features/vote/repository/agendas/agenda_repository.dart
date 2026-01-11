import 'package:diary/core/core.dart';

part 'agenda_repository_impl.dart';

abstract interface class AgendaRepository {
  Future<AgendasRow> insert({String? id, required String title});

  Future<AgendasRow?> findById(String id);

  Future<Iterable<AgendasRow>> fetch({
    DateTime? lastCreatedAt, // cursor
    int limit = 20,
  });

  Future<AgendasRow> update({required String id, required String title});

  Future<void> delete(String id);
}
