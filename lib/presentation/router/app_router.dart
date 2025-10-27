import 'package:auto_route/auto_route.dart';
import 'package:diary/presentation/pages/diary/create/p_create_diary.dart';
import 'package:diary/presentation/pages/home/p_home.dart';
import 'package:injectable/injectable.dart';

part 'app_router.gr.dart';

@lazySingleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  late final List<AutoRoute> routes = [
    AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: CreateDiaryRoute.page),
  ];
}
