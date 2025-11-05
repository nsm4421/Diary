import 'package:equatable/equatable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'diary_media_asset.g.dart';

@CopyWith(copyWithNull: true)
class DiaryMediaAsset extends Equatable {
  final String absolutePath;
  final String relativePath;
  final String fileName;
  final String? mimeType;
  final int? sizeInBytes;
  final int? width;
  final int? height;
  final int? sortOrder;

  const DiaryMediaAsset({
    required this.absolutePath,
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
    absolutePath,
    relativePath,
    fileName,
    mimeType,
    sizeInBytes,
    width,
    height,
    sortOrder,
  ];
}
