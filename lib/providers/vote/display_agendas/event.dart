part of 'bloc.dart';

@freezed
sealed class DisplayAgendaEvent
    with _$DisplayAgendaEvent
    implements DisplayEvent {
  factory DisplayAgendaEvent.refreshed() = _RefreshEvent;

  factory DisplayAgendaEvent.fetch() = _FetchEvent;

  factory DisplayAgendaEvent.append(AgendaFeedModel feed) = _AppendEvent;

  factory DisplayAgendaEvent.updated(AgendaFeedModel feed) = _UpdatedEvent;

  factory DisplayAgendaEvent.reaction({
    required String agendaId,
    VoteReaction? reaction,
  }) = _ReactionEvent;
}
