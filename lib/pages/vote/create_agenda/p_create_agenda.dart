import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:diary/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared/shared.dart';
import 'package:vote/vote.dart';

import '../../../providers/create_agenda/cubit.dart';

part 's_create_agenda.dart';

part 'f_form.dart';

part 'f_choices.dart';

part 'w_submit_button.dart';

@RoutePage()
class CreateAgendaPage extends StatelessWidget with UuidMixIn {
  const CreateAgendaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final agendaId = genUuid();
    return BlocProvider(
      create: (_) => GetIt.instance<CreateAgendaCubit>(param1: agendaId),
      child: BlocConsumer<CreateAgendaCubit, CreateAgendaState>(
        listener: (context, state) async {
          if (state.status.isSuccess) {
            // TODO : pop
            final created = state.created!;
            await context.maybePop(created);
          } else if (state.status.isError) {
            // TODO : snackbar 띄우기
            context.read<CreateAgendaCubit>().resetStatus();
          }
        },
        builder: (context, state) {
          if (state.status.isLoading || state.status.isSuccess) {
            return Center(child: CircularProgressIndicator());
          }
          return _Screen();
        },
      ),
    );
  }
}
