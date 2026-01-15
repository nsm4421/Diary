import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared/shared.dart';

part 'agenda_with_choices_model.g.dart';

part 'agenda_with_choices_model.freezed.dart';

@freezed
@JsonSerializable()
class AgendaWithChoicesModel extends BaseModel with _$AgendaWithChoicesModel {
  @override
  final String id;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'created_by')
  final String createdBy;
  @override
  @JsonKey(name: 'like_count')
  final int likeCount;
  @override
  @JsonKey(name: 'dislike_count')
  final int dislikeCount;
  @override
  @JsonKey(name: 'comment_count')
  final int commentCount;
  @override
  @JsonKey(name: 'choices')
  final List<({int position, String label})> choices;

  AgendaWithChoicesModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    this.description = '',
    required this.createdBy,
    this.likeCount = 0,
    this.dislikeCount = 0,
    this.commentCount = 0,
    this.choices = const [],
  });

  factory AgendaWithChoicesModel.fromJson(Map<String, Object?> json) =>
      _$AgendaWithChoicesModelFromJson(json);
}
