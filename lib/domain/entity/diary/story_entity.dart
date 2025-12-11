import 'package:copy_with_extension/copy_with_extension.dart';

import '../../entity/base_entity.dart';

part 'story_entity.g.dart';

@CopyWith(copyWithNull: true)
class StoryEntity extends BaseEntity {
  final String description;
  final List<String> media;
  final int sequence;

  StoryEntity({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
    required this.description,
    this.media = const [],
    this.sequence = 0,
  });
}
