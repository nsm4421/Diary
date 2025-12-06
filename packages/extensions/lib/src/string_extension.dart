import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

extension StringExtension on String {
  String? get mimeType {
    final extension = p.extension(this).toLowerCase();
    return switch (extension) {
      '.png' => 'image/png',
      '.jpg' => 'image/jpeg',
      '.jpeg' => 'image/jpeg',
      '.webp' => 'image/webp',
      '.gif' => 'image/gif',
      _ => null,
    };
  }

  String get hash => sha256.convert(utf8.encode(trim())).toString();
}
