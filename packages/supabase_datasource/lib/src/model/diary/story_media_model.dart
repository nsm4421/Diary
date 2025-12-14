import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_media_model.g.dart';

part 'story_media_model.freezed.dart';

@freezed
@JsonSerializable()
class StoryMediaModel with _$StoryMediaModel {
  @override
  final String id;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;
  @override
  @JsonKey(name: 'created_by')
  final String createdBy;

  @override
  @JsonKey(name: 'diary_id')
  final String diaryId;
  @override
  @JsonKey(name: 'story_id')
  final String storyId;
  @override
  final int sequence;
  @override
  final String filename;
  @override
  final String extension;
  @override
  final String path;

  StoryMediaModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.createdBy,
    required this.diaryId,
    required this.storyId,
    this.sequence = 0,
    required this.filename,
    required this.extension,
    required this.path,
  });

  factory StoryMediaModel.fromJson(Map<String, dynamic> json) =>
      _$StoryMediaModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoryMediaModelToJson(this);
}
