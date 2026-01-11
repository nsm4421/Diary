import 'package:diary/core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'agenda_option_model.freezed.dart';

@freezed
class AgendaOptionModel with _$AgendaOptionModel {
  @override
  final String id;
  @override
  final String agendaId;
  @override
  final int sequence;
  @override
  final String content;
  @override
  final int choiceCount;
  @override
  final bool choiceByMe;

  AgendaOptionModel({
    required this.id,
    required this.agendaId,
    this.sequence = 0,
    required this.content,
    this.choiceCount = 0,
    this.choiceByMe = false,
  });

  factory AgendaOptionModel.fromRow(
    AgendaOptionsRow row, {
    bool choiceByMe = false,
  }) {
    return AgendaOptionModel(
      id: row.id,
      agendaId: row.agendaId,
      sequence: row.sequence,
      content: row.content,
      choiceByMe: choiceByMe,
    );
  }
}
