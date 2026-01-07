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

  AgendaOptionModel({
    required this.id,
    required this.agendaId,
    this.sequence = 0,
    required this.content,
  });

  factory AgendaOptionModel.fromRow(AgendaOptionsRow row) {
    return AgendaOptionModel(
      id: row.id,
      agendaId: row.agendaId,
      sequence: row.sequence,
      content: row.content,
    );
  }
}
