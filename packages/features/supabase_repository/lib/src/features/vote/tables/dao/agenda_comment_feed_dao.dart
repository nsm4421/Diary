part of '../agenda_tables_repository_impl.dart';

class AgendaCommentFeedDao {
  final db.AgendaCommentFeedTable _table;

  AgendaCommentFeedDao(this._table);

  Future<Iterable<AgendaCommentModel>> fetchAgendaComments({
    required String agendaId,
    String? parentCommentId,
    String? lastCommentId,
    DateTime? lastCommentCreatedAt,
    int limit = 20,
  }) async {
    return await _table
        .queryRows(
          queryFn: (q) {
            var query = q;
            query = lastCommentCreatedAt == null
                ? query
                : query.lt(
                    'created_at',
                    lastCommentCreatedAt.toUtc().toIso8601String(),
                  );
            query = lastCommentId == null
                ? query
                : query.neq('id', lastCommentId);
            query = parentCommentId == null
                ? query
                : query.eq('parent_comment_id', parentCommentId);
            return query
                .eq('agenda_id', agendaId)
                .order('created_at', ascending: false)
                .order('id', ascending: false)
                .limit(limit);
          },
          limit: limit,
        )
        .then((res) => res.map(_toModel));
  }

  AgendaCommentModel _toModel(db.AgendaCommentFeedRow row) =>
      AgendaCommentModel(
        id: row.id ?? '',
        createdAt: row.createdAt ?? DateTime.now().toUtc(),
        updatedAt: row.updatedAt ?? DateTime.now().toUtc(),
        agendaId: row.agendaId ?? '',
        parentId: row.parentId,
        content: row.content ?? '',
        deletedAt: row.deletedAt,
        author: ProfileModel(
          id: row.createdBy ?? '',
          username: row.createdByUsername ?? '',
          avatarUrl: row.createdByAvatarUrl,
        ),
      );
}
