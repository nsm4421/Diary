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
}
