part of 'cubit.dart';

@freezed
class CreateAgendaState with _$CreateAgendaState {
  @override
  final Status status;
  @override
  final String title;
  @override
  final String description;
  @override
  final List<String> choices;
  @override
  final Failure? failure;
  final AgendaWithChoicesModel? created;

  CreateAgendaState({
    this.status = Status.initial,
    this.title = '',
    this.description = '',
    this.choices = const [],
    this.failure,
    this.created,
  });
}
