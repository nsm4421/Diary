part of 'cubit.dart';

@freezed
sealed class AgendaReactionState with _$AgendaReactionState {
  factory AgendaReactionState.idle() = _IdleState;

  factory AgendaReactionState.onReaction(VoteReaction reaction) =
      _OnReactionState;

  factory AgendaReactionState.loading(VoteReaction? previous) = _LoadingState;
}

extension AgendaReactionStateExtension on AgendaReactionState {
  VoteReaction? get current =>
      mapOrNull(onReaction: (s) => s.reaction, loading: (s) => s.previous);

  bool get isLoading => mapOrNull(loading: (_) => true) ?? false;
}
