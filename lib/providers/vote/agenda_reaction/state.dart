part of 'cubit.dart';

typedef VoteReactionParams = ({
  String agendaId,
  int likeCount,
  int dislikeCount,
  VoteReaction? myReaction,
});

@freezed
class VoteReactonState with _$VoteReactonState {
  @override
  final Status status;
  @override
  final VoteReaction? reaction;
  @override
  final int likeCount;
  @override
  final int dislikeCount;

  VoteReactonState({
    this.status = Status.initial,
    this.reaction,
    this.likeCount = 0,
    this.dislikeCount = 0,
  });
}

extension VoteReactonStateExtension on VoteReactonState {
  bool get isLike => reaction == VoteReaction.like;

  bool get isDislike => reaction == VoteReaction.dislike;
}
