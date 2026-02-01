part of '../agenda_tables_repository_impl.dart';

class AgendaFeedDao {
  final db.AgendaFeedTable _table;

  AgendaFeedDao(this._table);

  Future<Iterable<AgendaFeedModel>> fetchAgendaFeed({
    String? lastAgendaId,
    DateTime? lastCreatedAt,
    int limit = 20,
  }) async {
    return await _table
        .queryRows(
          queryFn: (q) {
            var query = q;
            query = lastCreatedAt == null
                ? query
                : query.lt(
                    'created_at',
                    lastCreatedAt.toUtc().toIso8601String(),
                  );
            query = lastAgendaId == null
                ? query
                : query.neq('id', lastAgendaId);
            return query
                .order('created_at', ascending: false)
                .order('id', ascending: false)
                .limit(limit);
          },
          limit: limit,
        )
        .then((res) => res.map(_toModel));
  }

  AgendaFeedModel _toModel(db.AgendaFeedRow row) => AgendaFeedModel(
    id: row.id ?? '',
    createdAt: row.createdAt ?? DateTime.now(),
    updatedAt: row.updatedAt ?? DateTime.now(),
    title: row.title ?? '',
    description: row.description,
    reaction: VoteReaction.values
        .where(
          (e) =>
              e.toString().toUpperCase() ==
              row.myReaction.toString().toUpperCase(),
        )
        .firstOrNull,
    likeCount: row.likeCount ?? 0,
    dislikeCount: row.dislikeCount ?? 0,
    commentCount: row.commentCount ?? 0,
    author: ProfileModel(
      id: row.createdBy ?? '',
      username: row.createdByUsername ?? '',
      avatarUrl: row.createdByAvatarUrl,
    ),
  );
}
