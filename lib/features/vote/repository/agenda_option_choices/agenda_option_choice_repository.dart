import 'package:diary/core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'agenda_option_choice_repository_impl.dart';

abstract interface class AgendaOptionChoiceRepository {
  Future<AgendaOptionChoicesRow?> findClientChoice(String agendaId);

  Future<AgendaOptionChoicesRow> insertRow({
    required String agendaId,
    required String optionId,
  });

  Future<AgendaOptionChoicesRow> updateRow({
    required String agendaId,
    required String previousOptionId,
    required String currentOptionId,
  });

  Future<void> deleteRow(String agendaId);
}
