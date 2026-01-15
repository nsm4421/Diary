import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared/shared.dart';

import '../agenda_comment/agenda_comment_model.dart';

part 'agenda_feed_model.freezed.dart';

@freezed
class AgendaFeedModel extends BaseModel with _$AgendaFeedModel {
  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String title;
  @override
  final String? description;
  @override
  final ProfileModel author;
  @override
  final int likeCount;
  @override
  final int dislikeCount;
  @override
  final int commentCount;
  @override
  final AgendaCommentModel? latestComment;

  AgendaFeedModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    this.description,
    this.likeCount = 0,
    this.dislikeCount = 0,
    this.commentCount = 0,
    this.latestComment,
    required this.author,
  });
}
