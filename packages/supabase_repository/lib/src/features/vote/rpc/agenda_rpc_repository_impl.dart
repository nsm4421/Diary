import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vote/vote.dart';

@LazySingleton(as: AgendaRpcRepository)
class AgendaRpcRepositoryImpl
    with DevLoggerMixIn
    implements AgendaRpcRepository {
  final SupabaseClient _client;

  AgendaRpcRepositoryImpl(this._client);

  @override
  Future<AgendaWithChoicesModel> createAgendaWithChoices({
    required String agendaId,
    required String agendaTitle,
    String? agendaDescription,
    required List<(String choiceId, String label)> choices,
  }) async {
    try {
      final payload = choices.asMap().entries.map((entry) {
        return {
          'id': entry.value.$1,
          'label': entry.value.$2,
          'position': entry.key + 1,
        };
      }).toList();
      final params = {
        'p_agenda_id': agendaId,
        'p_agenda_title': agendaTitle,
        'p_agenda_description': agendaDescription,
        'p_choices': payload,
      };
      return await _client
          .rpc<Map<String, dynamic>>(
            'create_agenda_with_choices',
            params: params,
          )
          .then(AgendaWithChoicesModel.fromJson);
    } catch (error, stackTrace) {
      logE('create agenda with choices fails', error, stackTrace);
      rethrow;
    }
  }
}
