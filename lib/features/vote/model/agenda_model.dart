import 'package:diary/core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'agenda_option_model.dart';

part 'agenda_model.freezed.dart';

@freezed
class AgendaModel with _$AgendaModel {
  @override
  final String id;
  @override
  final String title;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final List<AgendaOptionModel> options;

  AgendaModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.options = const [],
  });

  factory AgendaModel.fromRow(AgendasRow row) {
    return AgendaModel(
      id: row.id,
      title: row.title,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
