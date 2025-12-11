import 'package:diary/domain/entity/diary/story_entity.dart';
import 'package:supabase_datasource/export.dart';

extension StoryModelX on StoryModel {
  StoryEntity toEntity() {
    return StoryEntity(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      description: description,
      sequence: sequence,
      media: media.toList(),
    );
  }
}
