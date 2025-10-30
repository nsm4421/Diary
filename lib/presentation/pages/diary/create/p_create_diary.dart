import 'package:auto_route/auto_route.dart';
import 'package:diary/core/extension/build_context_extension.dart';
import 'package:diary/domain/entity/diary_entry.dart';
import 'package:diary/presentation/provider/diary/create/create_diary_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 's_create_diary.dart';

part 'f_create_dairy_form.dart';

part 'w_submit_button.dart';

@RoutePage()
class CreateDiaryPage extends StatelessWidget {
  const CreateDiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<CreateDiaryCubit>(),
      child: BlocListener<CreateDiaryCubit, CreateDiaryState>(
        listener: (context, state) {
          if (state.isSuccess) {
            context.showToast('일기 작성 성공');
            context.pop();
            // TODO : pop
          } else if (state.isError) {
            context
              ..read<CreateDiaryCubit>().handleChange()
              ..showToast(state.failure?.message ?? '알수 없는 오류가 발생했습니다');
          }
        },
        child: _Screen(),
      ),
    );
  }
}
