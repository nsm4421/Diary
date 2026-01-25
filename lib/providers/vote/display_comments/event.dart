part of 'bloc.dart';

@freezed
sealed class DisplayAgendaCommentEvent
    with _$DisplayAgendaCommentEvent
    implements DisplayEvent {
  factory DisplayAgendaCommentEvent.refreshed() = _RefreshEvent;

  factory DisplayAgendaCommentEvent.fetch() = _FetchEvent;

  factory DisplayAgendaCommentEvent.append(AgendaCommentModel comment) = _AppendEvent;
}
