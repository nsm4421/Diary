import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../supabase/generated/database.dart';

@module
abstract class SupabaseModule {
  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;

  @lazySingleton
  AgendasTable get agendaTable => AgendasTable();

  @lazySingleton
  AgendaOptionChoicesTable get agendaOptionChoicesTable =>
      AgendaOptionChoicesTable();

  @lazySingleton
  AgendaOptionsTable get agendaOptionsTable => AgendaOptionsTable();
}
