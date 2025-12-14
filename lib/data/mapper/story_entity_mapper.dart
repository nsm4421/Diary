import 'package:diary/domain/entity/diary/story_entity.dart';
import 'package:diary/domain/entity/diary/story_media_entity.dart';
import 'package:supabase_datasource/export.dart';

extension StoryModelX on StoryModel {
  StoryEntity toEntity([List<StoryMediaEntity>? media]) {
    return StoryEntity(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      description: description,
      sequence: sequence,
      media: media ?? [],
    );
  }
}
