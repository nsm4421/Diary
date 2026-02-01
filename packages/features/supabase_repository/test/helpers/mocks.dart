import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_repository/src/generated/database.dart' as db;

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockAuthResponse extends Mock implements AuthResponse {}

class MockSession extends Mock implements Session {}

class MockUser extends Mock implements User {}

class MockAgendasTable extends Mock implements db.AgendasTable {}

class MockAgendaCommentsTable extends Mock implements db.AgendaCommentsTable {}

class MockAgendaReactionsTable extends Mock implements db.AgendaReactionsTable {}

class MockAgendaFeedTable extends Mock implements db.AgendaFeedTable {}
