import 'package:auto_route/auto_route.dart';
import 'package:diary/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../provider/create_agenda/create_agenda_bloc.dart';

part 's_create_agenda.dart';

part 'f_appbar.dart';

part 'f_create_agenda_form.dart';

part 'w_description.dart';

part 'w_title.dart';

part 'w_options.dart';

part 'w_submit_button.dart';

@RoutePage()
class CreateAgendaPage extends StatelessWidget {
  const CreateAgendaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<CreateAgendaBloc>(),
      child: BlocListener<CreateAgendaBloc, CreateState<CreateAgendaData>>(
        listener: (context, state) async {
          final bloc = context.read<CreateAgendaBloc>();
          if (state.isError) {
            Toast.failure(state.errorMessage ?? '생성에 실패했어요.');
            await Future.delayed(1500.durationInMilliSec, () {
              bloc.add(CreateEvent.reset());
            });
          } else if (state.isSuccess) {
            Toast.success('안건이 생성됐어요.');
            await Future.delayed(1500.durationInMilliSec, () {
              if (context.mounted && context.router.canPop()) {
                context.router.pop(bloc.created);
              }
            });
          }
        },
        child: _Screen(),
      ),
    );
  }
}
