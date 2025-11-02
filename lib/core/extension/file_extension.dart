import 'dart:io';
import 'package:path/path.dart' as p;

extension FileExtension on File {
  String get filename => p.basename(this.path);
}
