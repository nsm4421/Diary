import 'package:auth/auth.dart';
import 'package:auto_route/auto_route.dart';
import 'package:diary/core/core.dart';
import 'package:diary/providers/auth/app_auth/bloc.dart';
import 'package:diary/providers/vote/create_comment/cubit.dart';
import 'package:diary/providers/vote/display_comments/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vote/vote.dart';

part 's_display_agenda_comments.dart';

part 'f_comment_list.dart';

part 'f_show_comment_button.dart';

part 'f_comment_editor.dart';

@RoutePage()
class DisplayAgendaCommentPage extends StatelessWidget {
  const DisplayAgendaCommentPage({
    super.key,
    required String agendaId,
    String? parentCommentId,
  }) : _agendaId = agendaId,
       _parentCommentId = parentCommentId;

  final String _agendaId;
  final String? _parentCommentId;

  @override
  Widget build(BuildContext context) {
    final DisplayAgendaCommentParams params = (
      agendaId: _agendaId,
      parentCommentId: _parentCommentId,
    );
    return BlocProvider(
      create: (_) =>
          GetIt.instance<DisplayAgendaCommentBloc>(param1: params)
            ..add(DisplayAgendaCommentEvent.refreshed()),
      child: PopScope(
        canPop: false, // true면 뒤로가기 허용
        onPopInvokedWithResult: (didPop, result) {
          debugPrint('DisplayAgendaCommentPage pop|result:$result');
        },
        child: _Screen(),
      ),
    );
  }
}
