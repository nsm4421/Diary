import 'package:diary/providers/display/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';
import 'package:vote/vote.dart';

part 'state.dart';

@injectable
class DisplayAgendasBloc
    extends DisplayBloc<AgendaFeedModel, FetchAgendaFeedCursor> {
  static const int _pageSize = 20;

  final VoteService _voteService;

  DisplayAgendasBloc(this._voteService);

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
}
