import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_repository/src/features/vote/tables/agenda_tables_repository_impl.dart';

import '../generated/database.dart';

@module
abstract class SupabaseModule {
  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;

  @lazySingleton
  AgendaDao get agendaDao => AgendaDao(AgendasTable());

  @lazySingleton
  AgendaFeedDao get agendaFeedDao => AgendaFeedDao(AgendaFeedTable());

  @lazySingleton
  AgendaReactionDao get agendaReactionDao =>
      AgendaReactionDao(AgendaReactionsTable());

  @lazySingleton
  AgendaCommentDao get agendaCommentDao =>
      AgendaCommentDao(AgendaCommentsTable());

  @lazySingleton
  AgendaCommentFeedDao get agendaCommentFeedDao =>
      AgendaCommentFeedDao(AgendaCommentFeedTable());
}
