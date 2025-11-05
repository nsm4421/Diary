import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:diary/core/extension/build_context_extension.dart';
import 'package:diary/core/value_objects/constraint.dart';
import 'package:diary/domain/entity/diary_entity.dart';
import 'package:diary/presentation/provider/diary/create/create_diary_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

part 's_create_diary.dart';

part 'f_create_dairy_form.dart';
part 'f_select_media.dart';

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
            context
              ..showToast('일기 작성 성공')
              ..pop();
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
