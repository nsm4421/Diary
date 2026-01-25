part of 'bloc.dart';

typedef DisplayAgendaCommentParams = ({
  String agendaId,
  String? parentCommentId,
});

typedef DisplayAgendaCommentState =
    DisplayState<AgendaCommentModel, FetchAgendaCommentCursor>;
