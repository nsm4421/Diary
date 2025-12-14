import 'package:diary/domain/entity/diary/story_media_entity.dart';
import 'package:supabase_datasource/export.dart';

extension StoryMediaModelX on StoryMediaModel {
  StoryMediaEntity toEntity() {
    return StoryMediaEntity(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      sequence: sequence,
      filename: filename,
      extension: extension,
      path: path,
    );
  }
}
