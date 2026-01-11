import 'package:auto_route/auto_route.dart';
import 'package:diary/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../model/agenda_model.dart';
import '../../provider/agenda_detail/agenda_detail_bloc.dart';

part 's_fetched.dart';

part 's_loading.dart';

part 'f_appbar.dart';

part 'f_agenda.dart';

part 'f_comments.dart';

@RoutePage()
class AgendaDetailPage extends StatelessWidget {
  const AgendaDetailPage(this._agendaId, {super.key});

  final String _agendaId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<AgendaDetailBloc>(param1: _agendaId)
            ..add(AgendaDetailEvent.started(_agendaId)),
      child: BlocBuilder<AgendaDetailBloc, AgendaDetailState>(
        builder: (context, state) {
          return (state.mounted && state.data != null)
              ? _FetchedScreen(state.data!)
              : _LoadingScreen();
        },
      ),
    );
  }
}
