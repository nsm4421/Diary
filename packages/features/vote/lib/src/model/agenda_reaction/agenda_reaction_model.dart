import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared/shared.dart';

part 'agenda_reaction_model.freezed.dart';

enum VoteReaction { like, dislike }

@freezed
class AgendaReactionModel extends BaseModel with _$AgendaReactionModel {
  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String agendaId;
  @override
  final String createdBy;
  @override
  final VoteReaction reaction;

  AgendaReactionModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.agendaId,
    required this.createdBy,
    required this.reaction,
  });
}
