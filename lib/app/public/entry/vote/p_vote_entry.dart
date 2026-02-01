import 'package:auth/auth.dart';
import 'package:auto_route/auto_route.dart';
import 'package:diary/components/auth_required_dialog.dart';
import 'package:diary/core/core.dart';
import 'package:diary/providers/auth/app_auth/bloc.dart';
import 'package:diary/providers/base/display/bloc.dart';
import 'package:diary/providers/vote/agenda_reaction/cubit.dart';
import 'package:diary/providers/vote/display_agendas/bloc.dart';
import 'package:diary/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vote/vote.dart';

part 's_display_agendas.dart';

part 'f_feed_list.dart';

part 'w_filter_chips.dart';

part 'w_agenda_card.dart';

part 'w_navigate_button.dart';

part 'w_reaction_buttons.dart';

part 'w_reaction_stat.dart';

part 'w_comment_stat.dart';

@RoutePage()
class VoteEntryPage extends StatelessWidget {
  const VoteEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
      GetIt.instance<DisplayAgendasBloc>()
        ..add(DisplayAgendaEvent.refreshed()),
      child: DisplayAgendasScreen(),
    );
  }
}
