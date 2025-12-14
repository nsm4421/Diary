import 'package:diary/domain/entity/diary/diary_entity.dart';
import 'package:diary/domain/entity/diary/story_entity.dart';
import 'package:supabase_datasource/export.dart';

extension DiaryModelX on DiaryModel {
  DiaryEntity toEntity([List<StoryEntity>? stories]) {
    return DiaryEntity(
      id: this.id,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      title: this.title,
      stories: stories ?? [],
    );
  }
}
