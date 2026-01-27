part of 'bloc.dart';

@freezed
sealed class AgendaDetailEvent with _$AgendaDetailEvent{
  factory AgendaDetailEvent.fetch() = _FetchEvent;
}