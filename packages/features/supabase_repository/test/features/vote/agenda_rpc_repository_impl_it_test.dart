@Tags(['integration'])
import 'dart:io';
import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_repository/src/features/vote/rpc/agenda_rpc_repository_impl.dart';
import 'package:test/test.dart';
import 'package:vote/vote.dart';

void main() {
  late SupabaseClient client;
  late AgendaRpcRepository repository;
  final createdAgendaIds = <String>[];
  var clientReady = false;

  setUpAll(() async {
    final env = _loadDotEnv();
    final apiUrl = Platform.environment['SUPABASE_API_URL'] ??
        env['SUPABASE_API_URL'] ??
        env['SUPABASE_URL'];
    final anonKey = Platform.environment['SUPABASE_PUBLISHABLE_KEY'] ??
        env['SUPABASE_PUBLISHABLE_KEY'] ??
        env['SUPABASE_ANON_KEY'] ??
        env['SUPABASE_KEY'];

    if (apiUrl == null || anonKey == null) {
      throw StateError(
        'Missing SUPABASE_API_URL/SUPABASE_PUBLISHABLE_KEY. '
        'Set env vars or add packages/supabase_repository/.env.local.',
      );
    }

    client = SupabaseClient(apiUrl, anonKey);
    repository = AgendaRpcRepositoryImpl(client);

    final email = _randomEmail();
    final password = _randomPassword();
    final signUpResponse =
        await client.auth.signUp(email: email, password: password);
    if (signUpResponse.session == null) {
      final signInResponse =
          await client.auth.signInWithPassword(email: email, password: password);
      if (signInResponse.session == null) {
        throw StateError('Failed to establish an authenticated session.');
      }
    }

    if (client.auth.currentUser == null) {
      throw StateError('Auth succeeded but no current user is available.');
    }

    clientReady = true;
  });

  tearDownAll(() async {
    if (!clientReady) {
      return;
    }
    for (final agendaId in createdAgendaIds) {
      try {
        await client.from('agendas').delete().eq('id', agendaId);
      } catch (_) {
        // Best-effort cleanup; ignore failures to avoid masking test results.
      }
    }
    await client.auth.signOut();
  });

  test('createAgendaWithChoices returns the created agenda and choices', () async {
    final agendaId = _uuidV4();
    final choices = [
      (_uuidV4(), 'Option A'),
      (_uuidV4(), 'Option B'),
    ];

    final result = await repository.createAgendaWithChoices(
      agendaId: agendaId,
      agendaTitle: 'Integration Agenda',
      agendaDescription: 'Created via integration test.',
      choices: choices,
    );
    createdAgendaIds.add(agendaId);

    expect(result.id, agendaId);
    expect(result.title, 'Integration Agenda');
    expect(result.description, 'Created via integration test.');
    expect(result.createdBy, client.auth.currentUser!.id);
    expect(result.choices, hasLength(2));
    expect(result.choices.first.position, 1);
    expect(result.choices.first.label, 'Option A');
    expect(result.choices.last.position, 2);
    expect(result.choices.last.label, 'Option B');
  });
}

Map<String, String> _loadDotEnv() {
  final file = _findEnvFile();
  if (file == null) {
    return {};
  }
  final lines = file.readAsLinesSync();
  final values = <String, String>{};
  for (final line in lines) {
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) {
      continue;
    }
    final separatorIndex = trimmed.indexOf('=');
    if (separatorIndex <= 0) {
      continue;
    }
    final key = trimmed.substring(0, separatorIndex).trim();
    final value = trimmed.substring(separatorIndex + 1).trim();
    values[key] = value;
  }
  return values;
}

File? _findEnvFile() {
  const candidates = [
    'packages/supabase_repository/.env.local',
    '.env.local',
  ];
  for (final path in candidates) {
    final file = File(path);
    if (file.existsSync()) {
      return file;
    }
  }
  return null;
}

String _randomEmail() {
  final seed = DateTime.now().microsecondsSinceEpoch;
  final suffix = Random(seed).nextInt(100000);
  return 'integration_$seed$suffix@example.com';
}

String _randomPassword() {
  final seed = DateTime.now().microsecondsSinceEpoch;
  final suffix = Random(seed).nextInt(10000);
  return 'TestPass!$seed$suffix';
}

String _uuidV4() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-'
      '${hex.substring(8, 12)}-'
      '${hex.substring(12, 16)}-'
      '${hex.substring(16, 20)}-'
      '${hex.substring(20, 32)}';
}
