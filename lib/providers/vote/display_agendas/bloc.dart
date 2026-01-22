import 'package:diary/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';
import 'package:vote/vote.dart';

import '../../base/display/bloc.dart';

part 'state.dart';

part 'event.dart';

part 'bloc.freezed.dart';

@injectable
class DisplayAgendasBloc
    extends DisplayBloc<AgendaFeedModel, FetchAgendaFeedCursor> {
  static const int _pageSize = 20;

  final VoteService _voteService;

  DisplayAgendasBloc(this._voteService) {
    on<_RefreshEvent>(_onRefresh, transformer: restartable());
    on<_FetchEvent>(_onFetchMore, transformer: restartable());
    on<_AppendEvent>(_onAppended, transformer: droppable());
    on<_UpdatedEvent>(_onUpdated, transformer: droppable());
    on<_ReactionEvent>(_onReaction, transformer: restartable());
  }

  @override
  TaskEither<
    Failure,
    DisplayFetchResult<AgendaFeedModel, FetchAgendaFeedCursor>
  >
  fetch({FetchAgendaFeedCursor? cursor}) {
    final safeCursor = cursor ?? (lastAgendaId: null, lastCreatedAt: null);

    return _voteService
        .fetchAgendaFeed(cursor: safeCursor, limit: _pageSize)
        .mapLeft<Failure>((failure) => failure)
        .map(
          (items) => (
            items: items,
            cursor: _buildNextCursor(items, safeCursor),
            isEnd: items.length < _pageSize,
          ),
        );
  }

  FetchAgendaFeedCursor _buildNextCursor(
    List<AgendaFeedModel> items,
    FetchAgendaFeedCursor fallback,
  ) {
    if (items.isEmpty) return fallback;
    final lastItem = items.last;
    return (lastAgendaId: lastItem.id, lastCreatedAt: lastItem.createdAt);
  }

  Future<void> _onRefresh(
    _RefreshEvent event,
    Emitter<DisplayAgendasState> emit,
  ) async {
    if (state.status.isLoading) return;
    await callApi(emit, cursor: state.cursor, append: false);
  }

  Future<void> _onFetchMore(
    _FetchEvent event,
    Emitter<DisplayAgendasState> emit,
  ) async {
    if (!state.canFetchMore || state.status.isLoading) return;
    await callApi(emit, cursor: state.cursor, append: true);
  }

  Future<void> _onAppended(
    _AppendEvent event,
    Emitter<DisplayAgendasState> emit,
  ) async {
    emit(state.copyWith(items: [event.feed, ...state.items]));
  }

  Future<void> _onUpdated(
    _UpdatedEvent event,
    Emitter<DisplayAgendasState> emit,
  ) async {
    emit(
      state.copyWith(
        items: state.items
            .map((e) => e.id == event.feed.id ? event.feed : e)
            .toList(growable: false),
      ),
    );
  }

  Future<void> _onReaction(
    _ReactionEvent event,
    Emitter<DisplayAgendasState> emit,
  ) async {
    emit(
      state.copyWith(
        items: state.items
            .map(
              (e) => e.id == event.agendaId
                  ? e.copyWith(reaction: event.reaction)
                  : e,
            )
            .toList(growable: false),
      ),
    );
  }
}
