import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_datasource/export.dart';

part 'diary_detail_model.g.dart';

part 'diary_detail_model.freezed.dart';

@freezed
@JsonSerializable()
class DiaryDetailModel with _$DiaryDetailModel {
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
  final String? title;
  @override
  final List<StoryModel> stories;

  DiaryDetailModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.createdBy,
    this.title,
    this.stories = const [],
  });

  factory DiaryDetailModel.fromJson(Map<String, dynamic> json) =>
      _$DiaryDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryDetailModelToJson(this);
}
