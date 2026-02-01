part of 'bloc.dart';

@freezed
sealed class AgendaDetailEvent with _$AgendaDetailEvent {
  factory AgendaDetailEvent.started() = _StartedEvent;

  factory AgendaDetailEvent.choiceSelected({
    required String userChoiceId,
    required String userId,
  }) = _ChoiceSeletedEvent;

  factory AgendaDetailEvent.choiceUnselected(String userId) = _ChoiceUnselected;

  factory AgendaDetailEvent.optimisticUpdateComment({
    required int commentCountDelta,
    String? lastestCommentContent,
  }) = _CommentUpdatedEvent;
}
