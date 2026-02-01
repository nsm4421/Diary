import 'package:freezed_annotation/freezed_annotation.dart';

part 'agenda_choice_model.freezed.dart';

part 'agenda_choice_model.g.dart';

@freezed
@JsonSerializable()
class AgendaChoiceModel with _$AgendaChoiceModel {
  @override
  final String id;
  @override
  final String label;
  @override
  final String? description;
  @override
  final int position;
  @override
  @JsonKey(name: 'vote_count')
  final int voteCount;

  AgendaChoiceModel({
    required this.id,
    required this.label,
    this.description,
    this.position = 0,
    this.voteCount = 0,
  });

  factory AgendaChoiceModel.fromJson(Map<String, Object?> json) =>
      _$AgendaChoiceModelFromJson(json);
}
