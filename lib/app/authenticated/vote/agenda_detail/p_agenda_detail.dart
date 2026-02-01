import 'dart:math';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:diary/app/authenticated/vote/display_agenda_comments/p_display_agenda_comment.dart';
import 'package:diary/components/agenda_reaction_buttons.dart';
import 'package:diary/components/profile_avatar.dart';
import 'package:diary/core/core.dart';
import 'package:diary/providers/auth/app_auth/bloc.dart';
import 'package:diary/providers/vote/agenda_detail/bloc.dart';
import 'package:diary/providers/vote/agenda_reaction/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared/shared.dart';
import 'package:vote/vote.dart';

part 's_agenda_detail.dart';

part 's_fetch_failed.dart';

part 'f_choices.dart';

part 'f_agenda_overview.dart';

part 'f_comment_section.dart';

part 'w_on_choice_selected.dart';

part 'w_on_choice_unselected.dart';

@RoutePage()
class AgendaDetailPage extends StatelessWidget {
  const AgendaDetailPage(this._agendaId, {super.key});

  final String _agendaId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<AgendaDetailBloc>(param1: _agendaId)
            ..add(AgendaDetailEvent.started()),
      child: BlocBuilder<AgendaDetailBloc, AgendaDetailState>(
        builder: (context, state) {
          final agenda = state.agenda;
          if (agenda != null) {
            final VoteReactionParams params = (
              agendaId: state.agenda!.id,
              likeCount: state.agenda!.likeCount,
              dislikeCount: state.agenda!.dislikeCount,
              myReaction: state.agenda?.myReaction,
            );
            return BlocProvider(
              create: (_) => GetIt.instance<VoteReactionCubit>(param1: params),
              child: _AgendaDetailScreen(state.agenda!),
            );
          }
          if (agenda == null && state.failure != null) {
            return _FetchFailedScreen(
              state.failure ?? Failure(message: '알수 없는 오류가 발생했습니다'),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
