part of 'agenda_detail_bloc.dart';

@freezed
abstract class AgendaDetailState with _$AgendaDetailState {
  const factory AgendaDetailState.idle(String agendaId) = _Idle;

  const factory AgendaDetailState.mounting(String agendaId) = _Mounting;

  const factory AgendaDetailState.failFetching({
    required String agendaId,
    required Failure failure,
  }) = _FailFetching;

  const factory AgendaDetailState.fetched(AgendaModel agenda) = _Fetched;

  const factory AgendaDetailState.loading(AgendaModel agenda) = _Loading;

  const factory AgendaDetailState.failure({
    required AgendaModel agenda,
    required Failure failure,
  }) = _Failure;
}

extension AgendaDetailStateExtension on AgendaDetailState {
  bool get mounted => maybeMap(
    idle: (_) => false,
    mounting: (_) => false,
    failFetching: (_) => false,
    orElse: () => true,
  );

  AgendaModel? get data => maybeMap(
    fetched: (s) => s.agenda,
    loading: (s) => s.agenda,
    failure: (s) => s.agenda,
    orElse: () => null,
  );
}
