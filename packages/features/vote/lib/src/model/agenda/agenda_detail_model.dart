import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared/shared.dart';

import '../../../vote.dart';

part 'agenda_detail_model.g.dart';

part 'agenda_detail_model.freezed.dart';

@freezed
@JsonSerializable()
class AgendaDetailModel extends BaseModel with _$AgendaDetailModel {
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
  @JsonKey(name: 'like_count')
  final int likeCount;
  @override
  @JsonKey(name: 'dislike_count')
  final int dislikeCount;
  @override
  @JsonKey(name: 'comment_count')
  final int commentCount;
  @override
  @JsonKey(name: 'author_id')
  final String authorId;
  @override
  @JsonKey(name: 'author_username')
  final String authorUsername;
  @override
  @JsonKey(name: 'author_avatar_url')
  final String? authorAvatarUrl;
  @override
  @JsonKey(name: 'my_reaction')
  final VoteReaction? myReaction;
  @override
  @JsonKey(name: 'my_choice_id')
  final String? myChoiceId;

  ProfileModel get author => ProfileModel(
    id: authorId,
    username: authorUsername,
    avatarUrl: authorAvatarUrl,
  );

  AgendaDetailModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    this.description = '',
    this.likeCount = 0,
    this.dislikeCount = 0,
    this.commentCount = 0,
    required this.authorId,
    required this.authorUsername,
    this.authorAvatarUrl,
    this.myReaction,
    this.myChoiceId,
  });

  factory AgendaDetailModel.fromJson(Map<String, Object?> json) =>
      _$AgendaDetailModelFromJson(json);
}
