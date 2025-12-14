import 'package:copy_with_extension/copy_with_extension.dart';

import '../../entity/base_entity.dart';
import 'story_entity.dart';

part 'diary_entity.g.dart';

@CopyWith(copyWithNull: true)
class DiaryEntity extends BaseEntity {
  final String? title;
  final List<StoryEntity> stories;
  final int storyCount;

  DiaryEntity({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    this.title,
    this.stories = const [],
    this.storyCount = 0
  });
}
