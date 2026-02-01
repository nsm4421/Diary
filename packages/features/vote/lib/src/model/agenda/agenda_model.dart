import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared/shared.dart';

part 'agenda_model.freezed.dart';

@freezed
class AgendaModel extends BaseModel with _$AgendaModel {
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
  final String createdBy;
  @override
  final int likeCount;
  @override
  final int dislikeCount;
  @override
  final int commentCount;

  AgendaModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    this.description = '',
    required this.createdBy,
    this.likeCount = 0,
    this.dislikeCount = 0,
    this.commentCount = 0,
  });
}
