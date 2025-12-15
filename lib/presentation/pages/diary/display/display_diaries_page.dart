import 'package:app_extensions/export.dart';
import 'package:auto_route/auto_route.dart';
import 'package:diary/core/constant/constraint.dart';
import 'package:diary/domain/entity/diary/diary_entity.dart';
import 'package:diary/presentation/provider/diary/create_diary/create_diary_cubit.dart';
import 'package:diary/presentation/provider/diary/display_diaries/display_diaries_bloc.dart';
import 'package:diary/presentation/provider/base/display_bloc/display_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'display_diaries_screen.dart';

part 'create_diary_modal_fragment.dart';

part 'diaries_list_fragment.dart';

@RoutePage()
class DisplayDiariesPage extends StatelessWidget {
  const DisplayDiariesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              GetIt.instance<DisplayDiariesBloc>()..add(DisplayEvent.started()),
        ),
        BlocProvider(
          create: (_) => GetIt.instance<CreateDiaryCubit>()..initialize(),
        ),
      ],
      child: BlocListener<CreateDiaryCubit, CreateDiaryState>(
        listenWhen: (_, curr) => (curr.isCreated || curr.isFailure),
        listener: (context, state) async {
          if (state.isCreated && state.created != null) {
            context
              ..showToast('Diary Created')
              ..read<DisplayDiariesBloc>().add(
                DisplayEvent.created(state.created!),
              );
          } else if (state.isFailure && state.failure != null) {
            context.showToast(state.failure!.message);
          }
          await Future.delayed(Duration(milliseconds: 1500), () {
            if (context.mounted) {
              context.read<CreateDiaryCubit>().initialize();
            }
          });
        },
        child: _DisplayDiariesScreen(),
      ),
    );
  }
}
