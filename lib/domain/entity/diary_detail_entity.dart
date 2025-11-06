import 'package:copy_with_extension/copy_with_extension.dart';

import 'diary_entity.dart';
import 'diary_media_asset.dart';

part 'diary_detail_entity.g.dart';

@CopyWith(copyWithNull: true)
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
