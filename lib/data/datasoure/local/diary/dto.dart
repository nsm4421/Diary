import 'package:diary/data/datasoure/local/database/local_database.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class CreateDiaryRequestDto {
  late final String id;
  final String? title;
  final String content;
  final List<CreateDiaryMediaRequestDto> medias;

  CreateDiaryRequestDto({
    String? clientId,
    required this.title,
    required this.content,
    List<CreateDiaryMediaRequestDto> medias = const [],
  }) : this.medias = List.unmodifiable(medias) {
    this.id = clientId ?? Uuid().v4();
  }

  DiaryRecordsCompanion toDiaryInsertable() {
    return DiaryRecordsCompanion.insert(
      id: Value(this.id),
      title: Value(this.title),
      content: this.content,
    );
  }

  Iterable<DiaryMediaRecordsCompanion> toDiaryMediaInsertable() {
    if (medias.isEmpty) {
      return const Iterable<DiaryMediaRecordsCompanion>.empty();
    }
    return medias.asMap().entries.map(
      (entry) =>
          entry.value.toInsertable(diaryId: id, fallbackSortOrder: entry.key),
    );
  }
}

class CreateDiaryMediaRequestDto {
  final String relativePath;
  final String fileName;
  final String? mimeType;
  final int? sizeInBytes;
  final int? width;
  final int? height;
  final int? sortOrder;

  const CreateDiaryMediaRequestDto({
    required this.relativePath,
    required this.fileName,
    this.mimeType,
    this.sizeInBytes,
    this.width,
    this.height,
    this.sortOrder,
  });

  DiaryMediaRecordsCompanion toInsertable({
    required String diaryId,
    int? fallbackSortOrder,
  }) {
    return DiaryMediaRecordsCompanion.insert(
      diaryId: diaryId,
      relativePath: relativePath,
      fileName: fileName,
      mimeType: Value(mimeType),
      sizeInBytes: Value(sizeInBytes),
      width: Value(width),
      height: Value(height),
      sortOrder: Value(sortOrder ?? fallbackSortOrder ?? 0),
    );
  }

  DiaryMediaRecordsCompanion toUpdateCompanion({int? fallbackSortOrder}) {
    return DiaryMediaRecordsCompanion(
      fileName: Value(fileName),
      mimeType: Value(mimeType),
      sizeInBytes: Value(sizeInBytes),
      width: Value(width),
      height: Value(height),
      sortOrder: Value(sortOrder ?? fallbackSortOrder ?? 0),
      relativePath: Value(relativePath),
    );
  }
}

class UpdateDiaryRequestDto extends CreateDiaryRequestDto {
  late String id;

  UpdateDiaryRequestDto({
    required this.id,
    required super.title,
    required super.content,
    super.medias,
  }) : super(clientId: id);
}
