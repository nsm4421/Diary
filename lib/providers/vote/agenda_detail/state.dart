part of 'bloc.dart';

@freezed
sealed class AgendaDetailState with _$AgendaDetailState {
  factory AgendaDetailState.idle({Failure? failure}) = _IdleState;

  factory AgendaDetailState.initializing() = _InitializingState;

  factory AgendaDetailState.choiceSelected({
    required AgendaDetailModel agenda,
    Failure? failure,
    required String userChoiceId,
  }) = _ChoiceSeleted;

  factory AgendaDetailState.choiceUnSelected({
    required AgendaDetailModel agenda,
    Failure? failure,
  }) = _ChoiceUnSelected;

  factory AgendaDetailState.loading({required AgendaDetailModel agenda}) =
      _LoadingState;
}

extension AgendaDetailStateExtension on AgendaDetailState {
  bool get isInitialized => map(
    idle: (_) => false,
    initializing: (_) => false,
    choiceSelected: (_) => true,
    choiceUnSelected: (_) => true,
    loading: (_) => false,
  );

  bool get isLoading =>
      mapOrNull(
        idle: (_) => false,
        initializing: (_) => true,
        loading: (_) => true,
      ) ??
      false;

  Failure? get failure => mapOrNull(
    idle: (e) => e.failure,
    choiceSelected: (e) => e.failure,
    choiceUnSelected: (e) => e.failure,
  );

  AgendaDetailModel? get agenda => mapOrNull(
    choiceSelected: (e) => e.agenda,
    choiceUnSelected: (e) => e.agenda,
    loading: (e) => e.agenda,
  );
}
