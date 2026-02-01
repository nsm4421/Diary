import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:diary/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:shared/shared.dart';
import 'package:vote/vote.dart';

import '../../base/display/bloc.dart';

part 'state.dart';

part 'event.dart';

part 'bloc.freezed.dart';

@injectable
class DisplayAgendaCommentBloc
    extends DisplayBloc<AgendaCommentModel, FetchAgendaCommentCursor> {
  final VoteService _voteService;
  late final String _agendaId;
  late final String? _parentCommentId;
  final Logger _logger;
  static const int _pageSize = 20;
  int _commentCountDelta = 0; // 추가된 댓글 개수
  String? _commentWrittenContent; // 유저가 작성한 최신 댓글

  DisplayAgendaCommentBloc(
    @factoryParam DisplayAgendaCommentParams params,
    this._voteService,
    this._logger,
  ) {
    _agendaId = params.agendaId;
    _parentCommentId = params.parentCommentId;
    on<_RefreshEvent>(_onRefresh, transformer: restartable());
    on<_FetchEvent>(_onFetchMore, transformer: restartable());
    on<_AppendEvent>(_onAppended, transformer: droppable());
  }

  String get agendaId => _agendaId;

  String? get parentCommentId => _parentCommentId;

  String? get commentWrittenContent => _commentWrittenContent;

  int get commentCountDelta => _commentCountDelta;

  @override
  TaskEither<
    Failure,
    DisplayFetchResult<AgendaCommentModel, FetchAgendaCommentCursor>
  >
  fetch({FetchAgendaCommentCursor? cursor}) {
    final safeCursor =
        cursor ??
        (
          agendaId: _agendaId,
          parentCommentId: _parentCommentId,
          lastCommentId: null,
          lastCommentCreatedAt: null,
        );

    return _voteService
        .fetchAgendaComments(cursor: safeCursor, limit: _pageSize)
        .mapLeft<Failure>((failure) => failure)
        .map(
          (items) => (
            items: items,
            cursor: _buildNextCursor(items, safeCursor),
            isEnd: items.length < _pageSize,
          ),
        );
  }

  FetchAgendaCommentCursor _buildNextCursor(
    List<AgendaCommentModel> items,
    FetchAgendaCommentCursor fallback,
  ) {
    if (items.isEmpty) return fallback;
    final lastItem = items.last;
    return (
      agendaId: _agendaId,
      parentCommentId: _parentCommentId,
      lastCommentId: lastItem.id,
      lastCommentCreatedAt: lastItem.createdAt,
    );
  }

  Future<void> _onRefresh(
    _RefreshEvent event,
    Emitter<DisplayAgendaCommentState> emit,
  ) async {
    if (state.status.isLoading) return;
    await callApi(emit, cursor: state.cursor, append: false);
  }

  Future<void> _onFetchMore(
    _FetchEvent event,
    Emitter<DisplayAgendaCommentState> emit,
  ) async {
    if (!state.canFetchMore || state.status.isLoading) return;
    await callApi(emit, cursor: state.cursor, append: true);
  }

  Future<void> _onAppended(
    _AppendEvent event,
    Emitter<DisplayAgendaCommentState> emit,
  ) async {
    _commentCountDelta++;
    _commentWrittenContent = event.comment.content;
    _logger.t(
      'comment appended|comment count delta:$_commentCountDelta|latest comment:$_commentWrittenContent',
    );
    emit(state.copyWith(items: [event.comment, ...state.items]));
  }
}
