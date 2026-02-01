import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import 'app_router.gr.dart';

@lazySingleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  List<AutoRoute> get _guestOnlyRoutes => [];

  List<AutoRoute> get _publicRoutes => [
    /// splash
    AutoRoute(path: '/splash', page: SplashRoute.page, initial: true),
  ];

  @override
  List<AutoRoute> get routes => [..._publicRoutes];
}
