import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary_model.g.dart';

part 'diary_model.freezed.dart';

@freezed
@JsonSerializable()
class DiaryModel with _$DiaryModel {
  @override
  final String id;
  @override
  final String? title;
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
  @JsonKey(name: 'story_count')
  final int storyCount;

  DiaryModel({
    required this.id,
    this.title,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.createdBy,
    this.storyCount = 0
  });

  factory DiaryModel.fromJson(Map<String, dynamic> json) =>
      _$DiaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryModelToJson(this);
}
