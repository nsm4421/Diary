import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:diary/core/extension/build_context_extension.dart';
import 'package:diary/core/constant/constraint.dart';
import 'package:diary/presentation/provider/diary/edit/edit_diary_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

part 's_create_diary.dart';

part 'f_editor.dart';

part 'f_select_media.dart';

part 'w_submit_button.dart';

part 'w_media_preview.dart';

part 'w_add_media_title.dart';

@RoutePage()
class EditDiaryPage extends StatelessWidget {
  const EditDiaryPage(this._diaryId, {super.key});

  final String? _diaryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<EditDiaryCubit>(param1: _diaryId)..init(),
      child: BlocListener<EditDiaryCubit, EditDiaryState>(
        listener: (context, state) {
          if (state.isSuccess) {
            context
              ..showToast('일기 작성 성공')
              ..pop();
          } else if (state.isError) {
            final message = state.errorMessage;
            context
              ..read<EditDiaryCubit>().handleChange()
              ..showToast(message);
          }
        },
        child: BlocBuilder<EditDiaryCubit, EditDiaryState>(
          builder: (context, state) {
            return state.isMounted
                ? _Screen()
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
