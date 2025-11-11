import 'package:auto_route/auto_route.dart';
import 'package:diary/core/extension/datetime_extension.dart';
import 'package:diary/domain/entity/diary_entity.dart';
import 'package:diary/presentation/components/diary/diary_preview_card.dart';
import 'package:diary/presentation/router/app_router.dart';
import 'package:flutter/material.dart';

part 's_search_diary.dart';

part 'result/s_searched_result.dart';

part 'f_search_option_card.dart';

part 'f_search_action_bar.dart';

part 'w_search_field.dart';

part 'w_criteria_body.dart';

@RoutePage()
class SearchDiaryPage extends StatelessWidget {
  const SearchDiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _Screen();
  }
}
