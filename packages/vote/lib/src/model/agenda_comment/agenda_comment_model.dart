import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared/shared.dart';

part 'agenda_comment_model.freezed.dart';

@freezed
class AgendaCommentModel extends BaseModel with _$AgendaCommentModel {
  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String agendaId;
  @override
  final String? parentId;
  @override
  final String content;
  @override
  final DateTime? deletedAt;
  @override
  final String createdBy;

  AgendaCommentModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.agendaId,
    this.parentId,
    required this.content,
    this.deletedAt,
    required this.createdBy,
  });
}
