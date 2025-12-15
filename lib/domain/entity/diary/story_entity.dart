import 'package:copy_with_extension/copy_with_extension.dart';

import '../base/base_entity.dart';
import 'story_media_entity.dart';

part 'story_entity.g.dart';

@CopyWith(copyWithNull: true)
class StoryEntity extends BaseEntity {
  final String description;
  final List<StoryMediaEntity> media;
  final int sequence;

  StoryEntity({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.description,
    this.sequence = 0,
    this.media = const [],
  });
}
