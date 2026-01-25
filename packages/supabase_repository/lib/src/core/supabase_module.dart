import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../generated/database.dart';

@module
abstract class SupabaseModule {
  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;

  @lazySingleton
  AgendasTable get agendaDao => AgendasTable();

  @lazySingleton
  AgendaReactionsTable get agendaReactionDao => AgendaReactionsTable();

  @lazySingleton
  AgendaCommentsTable get agendaCommentDao => AgendaCommentsTable();

  @lazySingleton
  AgendaCommentFeedTable get agendaCommentFeedDao => AgendaCommentFeedTable();

  @lazySingleton
  AgendaFeedTable get agendaFeedDao => AgendaFeedTable();
}
