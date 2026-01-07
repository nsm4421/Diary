import 'package:supabase_flutter/supabase_flutter.dart';

extension GoTrueClientExtension on GoTrueClient {
  String get clientId {
    final id = currentUser?.id;
    if (id == null) {
      throw AuthException('no user founded');
    }
    return id;
  }
}
