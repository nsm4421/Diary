import 'package:diary/domain/entity/diary/diary_entity.dart';
import 'package:supabase_datasource/export.dart';
import 'story_entity_mapper.dart';

extension DiaryModelX on DiaryModel {
  DiaryEntity toEntity() {
    return DiaryEntity(
      id: this.id,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      deletedAt: this.deletedAt,
      title: this.title
    );
  }
}

extension DiaryDetailModelX on DiaryDetailModel {
  DiaryWithStoryEntity toEntity() {
    return DiaryWithStoryEntity(
      id: this.id,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      deletedAt: this.deletedAt,
      title: this.title,
      stories: this.stories.map((e) => e.toEntity()).toList(),
    );
  }
}
