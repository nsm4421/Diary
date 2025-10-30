import 'package:auto_route/auto_route.dart';
import 'package:diary/presentation/pages/diary/create/p_create_diary.dart';
import 'package:diary/presentation/pages/diary/display/p_display_diary.dart';
import 'package:injectable/injectable.dart';

part 'app_router.gr.dart';

@lazySingleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  late final List<AutoRoute> routes = [
    AutoRoute(page: DisplayDiaryRoute.page, initial: true),
    CustomRoute(
      page: CreateDiaryRoute.page,
      transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
      duration: Duration(milliseconds: 400),
      reverseDuration: Duration(milliseconds: 400),
    ),
  ];
}
