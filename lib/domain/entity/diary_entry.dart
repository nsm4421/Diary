import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

const int kDiaryEntryMaxContentLength = 5000;
const int kDiaryEntryMaxTitleLength = 30;

@CopyWith(copyWithNull: true)
class DiaryEntity extends Equatable {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String date;
  final bool isTemp;
  final String? title;
  final String content;

  const DiaryEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.date,
    this.isTemp = false,
    this.title,
    this.content = '',
  });

  @override
  List<Object?> get props => [
    id,
    createdAt,
    updatedAt,
    date,
    isTemp,
    title,
    content,
  ];
}

class DiaryDetailEntity extends DiaryEntity {
  final List<DiaryMediaAsset> medias;

  DiaryDetailEntity({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.date,
    super.isTemp = false,
    super.title,
    super.content = '',
    List<DiaryMediaAsset> medias = const [],
  }) : medias = List.unmodifiable(medias);

  @override
  List<Object?> get props => [...super.props, medias];
}

class DiaryMediaAsset extends Equatable {
  final String relativePath;
  final String fileName;
  final String? mimeType;
  final int? sizeInBytes;
  final int? width;
  final int? height;
  final int? sortOrder;

  const DiaryMediaAsset({
    required this.relativePath,
    required this.fileName,
    this.mimeType,
    this.sizeInBytes,
    this.width,
    this.height,
    this.sortOrder,
  });

  @override
  List<Object?> get props => [
    relativePath,
    fileName,
    mimeType,
    sizeInBytes,
    width,
    height,
    sortOrder,
  ];
}
