import 'package:auto_route/auto_route.dart';
import 'package:diary/core/constant/diary_display_mode.dart';
import 'package:diary/core/constant/status.dart';
import 'package:diary/core/extension/build_context_extension.dart';
import 'package:diary/core/extension/datetime_extension.dart';
import 'package:diary/domain/entity/diary_entity.dart';
import 'package:diary/presentation/components/app_logo_hero.dart';
import 'package:diary/presentation/components/diary/diary_preview_card.dart';
import 'package:diary/presentation/provider/diary/display/calendar/display_calendar_bloc.dart';
import 'package:diary/presentation/provider/diary/delete/delete_diary_cubit.dart';
import 'package:diary/presentation/provider/diary/display/mode/display_diary_mode.dart';
import 'package:diary/presentation/provider/diary/display/pagination/display_diary_bloc.dart';
import 'package:diary/presentation/provider/display/display_bloc.dart';
import 'package:diary/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:table_calendar/table_calendar.dart';

part 's_display_diary.dart';

part 'dialog/f_dialog.dart';

part 'f_appbar.dart';

part 'calendar/f_calendar.dart';

part 'calendar/w_header.dart';

part 'calendar/w_calendar_grid.dart';

part 'calendar/w_preview.dart';

part 'calendar/w_select_month_modal.dart';

part 'feed/f_feed_style_diaries_list.dart';

part 'feed/w_empty_state.dart';

part 'feed/w_diary_card.dart';

@RoutePage()
class DisplayDiaryPage extends StatelessWidget {
  const DisplayDiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetIt.instance<DisplayDiaryModeCubit>()),
        BlocProvider(
          create: (_) =>
              GetIt.instance<DisplayDiaryBloc>()
                ..add(DisplayEvent<DiaryEntity>.started()),
        ),
        BlocProvider(
          create: (_) =>
              GetIt.instance<DisplayCalendarBloc>()
                ..add(DisplayCalendarEvent.started()),
        ),
      ],
      child: _Screen(),
    );
  }
}
