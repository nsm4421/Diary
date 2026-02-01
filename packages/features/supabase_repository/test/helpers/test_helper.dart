import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:postgrest/postgrest.dart';
import 'package:supabase_codegen/supabase_codegen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

PostgrestTransformBuilder<DictionaryList> _defaultQueryFn(
  PostgrestFilterBuilder<DictionaryList> builder,
) =>
    builder;

PostgrestTransformBuilder<dynamic> _defaultMatchFn(
  PostgrestFilterBuilder<dynamic> builder,
) =>
    builder;

void registerTestFallbacks() {
  registerFallbackValue(_defaultQueryFn);
  registerFallbackValue(_defaultMatchFn);
  registerFallbackValue(<String, dynamic>{});
  registerFallbackValue(SignOutScope.local);
}

Future<T> runSilently<T>(Future<T> Function() body) {
  return runZoned(
    body,
    zoneSpecification: ZoneSpecification(
      print: (_, __, ___, ____) {},
    ),
  );
}
