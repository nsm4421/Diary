import 'package:auto_route/auto_route.dart';
import 'package:diary/core/constant/status.dart';
import 'package:diary/core/extension/build_context_extension.dart';
import 'package:diary/domain/entity/diary_entity.dart';
import 'package:diary/presentation/components/app_logo_hero.dart';
import 'package:diary/presentation/components/diary/diary_preview_card.dart';
import 'package:diary/presentation/provider/diary/delete/delete_diary_cubit.dart';
import 'package:diary/presentation/provider/diary/display/pagination/display_diary_bloc.dart';
import 'package:diary/presentation/provider/display/display_bloc.dart';
import 'package:diary/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 's_display_diary.dart';

part 'f_appbar.dart';

part 'f_feed_list.dart';

part 'w_empty_state.dart';

part 'w_diary_card.dart';

part 'f_edit_dialog.dart';

@RoutePage()
class DisplayDiaryPage extends StatelessWidget {
  const DisplayDiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<DisplayDiaryBloc>()
            ..add(DisplayEvent<DiaryEntity>.started()),
      child: _Screen(),
    );
  }
}
