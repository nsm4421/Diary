import 'package:auto_route/auto_route.dart';
import 'package:diary/core/extension/build_context_extension.dart';
import 'package:diary/core/extension/datetime_extension.dart';
import 'package:diary/core/value_objects/diary.dart';
import 'package:diary/core/constant/status.dart';
import 'package:diary/domain/entity/diary_entity.dart';
import 'package:diary/presentation/provider/diary/display/display_diary.bloc.dart';
import 'package:diary/presentation/provider/display/display_bloc.dart';
import 'package:diary/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 's_searched_result.dart';

part 'f_diaries_list.dart';

part 'f_empty_view.dart';

part 'f_failure_view.dart';

@RoutePage()
class SearchedResultPage extends StatelessWidget {
  const SearchedResultPage(this._param, {super.key});

  final FetchDiaryParam _param;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<DisplayDiaryBloc>(param1: _param)
            ..add(DisplayEvent.started()),
      child: _Screen(_param),
    );
  }
}
