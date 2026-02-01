import 'package:auto_route/auto_route.dart';
import 'package:diary/core/core.dart';
import 'package:diary/providers/vote/create_agenda/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared/shared.dart';
import 'package:vote/vote.dart';

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
            ToastUtil.success('투표 작성 완료');
            await context.maybePop<AgendaWithChoicesModel>(state.created!);
          } else if (state.status.isError) {
            ToastUtil.error(state.failure?.message ?? 'error occurs');
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
