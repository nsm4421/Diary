import 'package:auto_route/auto_route.dart';
import 'package:diary/providers/display/bloc.dart';
import 'package:diary/providers/display_agendas/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../vote/display_agendas/s_display_agendas.dart';

@RoutePage()
class DisplayAgendasPage extends StatelessWidget {
  const DisplayAgendasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<DisplayAgendasBloc>()..add(DisplayRefreshEvent()),
      child: DisplayAgendasScreen(),
    );
  }
}
