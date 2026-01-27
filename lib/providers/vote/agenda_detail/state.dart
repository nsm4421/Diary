part of 'bloc.dart';

@freezed
class AgendaDetailState with _$AgendaDetailState {
  final Status status;
  final AgendaDetailModel? agenda;
  final Failure? failure;

  AgendaDetailState({this.status = Status.initial, this.agenda, this.failure});
}
