import 'package:copy_with_extension/copy_with_extension.dart';

import '../../entity/base_entity.dart';
import 'story_entity.dart';

part 'diary_entity.g.dart';

@CopyWith(copyWithNull: true)
class DiaryEntity extends BaseEntity {
  final String? title;

  DiaryEntity({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
    this.title,
  });
}

@CopyWith(copyWithNull: true)
class DiaryWithStoryEntity extends DiaryEntity {
  final List<StoryEntity> stories;

  DiaryWithStoryEntity({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
    super.title,
    this.stories = const [],
  });
}
