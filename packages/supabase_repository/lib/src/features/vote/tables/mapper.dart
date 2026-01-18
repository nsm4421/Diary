import 'package:shared/shared.dart';
import 'package:vote/vote.dart';

import '../../../generated/database.dart' as db;

extension AgendasRowExtension on db.AgendasRow {
  AgendaModel toModel() {
    return AgendaModel(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      title: title,
      description: description,
      createdBy: createdBy,
      likeCount: likeCount,
      dislikeCount: dislikeCount,
      commentCount: commentCount,
    );
  }
}

extension AgendaFeedRowExtension on db.AgendaFeedRow {
  AgendaFeedModel toModel() {
    return AgendaFeedModel(
      id: id ?? '',
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
      title: title ?? '',
      description: description,
      likeCount: likeCount ?? 0,
      dislikeCount: dislikeCount ?? 0,
      commentCount: commentCount ?? 0,
      author: ProfileModel(
        id: createdBy ?? '',
        username: createdByUsername ?? '',
        avatarUrl: createdByAvatarUrl,
      ),
    );
  }
}

extension VoteReactionExtension on VoteReaction {
  db.VoteReaction get dto {
    return switch (this) {
      VoteReaction.like => db.VoteReaction.like,
      VoteReaction.dislike => db.VoteReaction.dislike,
    };
  }
}

extension AgendaCommentExtension on db.AgendaCommentsRow {
  AgendaCommentModel toModel() {
    return AgendaCommentModel(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      agendaId: agendaId,
      parentId: parentId,
      content: content,
      deletedAt: deletedAt,
      createdBy: createdBy,
    );
  }
}
