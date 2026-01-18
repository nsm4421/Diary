typedef FetchAgendaFeedCursor = ({
  String? lastAgendaId,
  DateTime? lastCreatedAt,
});

typedef FetchAgendaCommentCursor = ({
  String agendaId,
  String? parentCommentId,
  String? lastCommentId,
  DateTime? lastCommentCreatedAt,
});
