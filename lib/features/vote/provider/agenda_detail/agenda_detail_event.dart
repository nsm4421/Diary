part of 'agenda_detail_bloc.dart';

@freezed
abstract class AgendaDetailEvent with _$AgendaDetailEvent {
  const factory AgendaDetailEvent.started(String agendaId) = _Started;

  const factory AgendaDetailEvent.voted(String optionId) = _Voted;
}
