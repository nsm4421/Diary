import 'package:uuid/uuid.dart';

class CreateDiaryRequestDto {
  late final String id;
  final String? title;
  final String content;

  CreateDiaryRequestDto({
    String? clientId,
    required this.title,
    required this.content,
  }) {
    this.id = clientId ?? Uuid().v4();
  }
}

class UpdateDiaryRequestDto {
  final String id;
  final String? title;
  final String content;

  UpdateDiaryRequestDto({
    required this.id,
    required this.title,
    required this.content,
  });
}
