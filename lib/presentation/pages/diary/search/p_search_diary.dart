import 'package:auto_route/auto_route.dart';
import 'package:diary/core/extension/build_context_extension.dart';
import 'package:diary/core/extension/datetime_extension.dart';
import 'package:diary/core/value_objects/diary.dart';
import 'package:diary/presentation/components/app_logo_hero.dart';
import 'package:diary/presentation/provider/diary/search/search_diary_cubit.dart';
import 'package:diary/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 's_search_diary.dart';

part 'f_search_title.dart';

part 'f_search_content.dart';

part 'f_pick_date_rage.dart';

part 'w_select_kind.dart';

@RoutePage()
class SearchDiaryPage extends StatelessWidget {
  const SearchDiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<SearchDiaryCubit>(),
      child: _Screen(),
    );
  }
}
