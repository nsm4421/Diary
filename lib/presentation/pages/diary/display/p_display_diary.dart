import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:diary/domain/entity/diary_entry.dart';
import 'package:diary/domain/usecase/diary/diary_usecases.dart';
import 'package:diary/presentation/provider/diary/display/display_diary.bloc.dart';
import 'package:diary/presentation/provider/display/display_bloc.dart';
import 'package:diary/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:diary/core/extension/datetime_extension.dart';
import 'package:diary/core/value_objects/status.dart';

part 's_display_diary.dart';

part 'f_diaries_list.dart';

@RoutePage()
class DisplayDiaryPage extends StatelessWidget {
  const DisplayDiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<DisplayDiaryBloc>()
            ..add(DisplayEvent<DiaryEntity, FetchDiaryParam>.started()),
      child: _Screen(),
    );
  }
}
