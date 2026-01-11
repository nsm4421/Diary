part of 'create_agenda_bloc.dart';

@freezed
class CreateAgendaData with _$CreateAgendaData {
  @override
  final String title;
  @override
  final String description;
  @override
  final List<String> options;

  CreateAgendaData({
    this.title = '',
    this.description = '',
    this.options = const [],
  });
}
