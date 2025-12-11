import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_model.g.dart';

part 'story_model.freezed.dart';

@freezed
@JsonSerializable()
class StoryModel with _$StoryModel {
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
  final int sequence;
  @override
  final String description;
  @override
  final Iterable<String> media;

  StoryModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.sequence = 0,
    required this.createdBy,
    required this.description,
    this.media = const [],
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);
}
