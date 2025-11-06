part of 'diary_repository.dart';

class CreateDiaryMediaRequest {
  final String relativePath;
  final String fileName;
  final String? mimeType;
  final int? sizeInBytes;
  final int? width;
  final int? height;
  final int? sortOrder;

  const CreateDiaryMediaRequest({
    required this.relativePath,
    required this.fileName,
    this.mimeType,
    this.sizeInBytes,
    this.width,
    this.height,
    this.sortOrder,
  });
}
