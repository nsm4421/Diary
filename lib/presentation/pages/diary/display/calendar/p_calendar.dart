import 'package:auto_route/auto_route.dart';
import 'package:diary/core/extension/build_context_extension.dart';
import 'package:diary/core/extension/datetime_extension.dart';
import 'package:diary/domain/entity/diary_entity.dart';
import 'package:diary/presentation/components/diary/diary_preview_card.dart';
import 'package:diary/presentation/components/diary/edit_dialog.dart';
import 'package:diary/presentation/pages/diary/display/p_display_diary.dart';
import 'package:diary/presentation/provider/diary/display/calendar/display_calendar_bloc.dart';
import 'package:diary/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:table_calendar/table_calendar.dart';

part 's_calendar.dart';

part 'w_header.dart';

part 'w_calendar_grid.dart';

part 'w_preview.dart';

part 'w_select_month_modal.dart';

@RoutePage()
class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<DisplayCalendarBloc>()
            ..add(DisplayCalendarEvent.started()),
      child: _Screen(),
    );
  }
}
