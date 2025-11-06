import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

part 's_search_diary.dart';

part 'w_search_field.dart';

@RoutePage()
class SearchDiaryPage extends StatelessWidget {
  const SearchDiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _Screen();
  }
}
