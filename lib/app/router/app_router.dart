import 'package:auto_route/auto_route.dart';
import 'package:diary/app/pages/auth/p_auth.dart';
import 'package:diary/app/pages/home/p_home.dart';
import 'package:diary/app/pages/splash/p_splash.dart';
import 'package:injectable/injectable.dart';

part 'app_router.gr.dart';

@lazySingleton
@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: HomeRoute.page),
  ];
}
