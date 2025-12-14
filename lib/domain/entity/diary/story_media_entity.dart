import 'package:copy_with_extension/copy_with_extension.dart';

import '../../entity/base_entity.dart';

part 'story_media_entity.g.dart';

@CopyWith(copyWithNull: true)
class StoryMediaEntity extends BaseEntity {
  final String filename;
  final String extension;
  final String path;
  final int sequence;

  StoryMediaEntity({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.filename,
    required this.extension,
    required this.path,
    this.sequence = 0,
  });
}
