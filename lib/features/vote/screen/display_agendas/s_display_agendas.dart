import 'package:auto_route/auto_route.dart';
import 'package:diary/app/router/app_router.dart';
import 'package:diary/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../model/agenda_model.dart';
import '../../provider/display_agendas/display_agendas_bloc.dart';

part 'f_agenda_list.dart';

part 'f_appbar.dart';

part 'w_agenda_item.dart';

@RoutePage()
class DisplayAgendasScreen extends StatelessWidget {
  const DisplayAgendasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<DisplayAgendasBloc>()..add(DisplayEvent.started()),
      child: Scaffold(
        appBar: _AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [_AgendaList()]),
          ),
        ),
      ),
    );
  }
}
