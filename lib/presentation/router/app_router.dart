import 'package:auto_route/auto_route.dart';
import 'package:diary/presentation/pages/auth/auth_entry_page.dart';
import 'package:diary/presentation/pages/home/home_entry_page.dart';
import 'package:diary/presentation/pages/splash/splash_page.dart';
import 'package:injectable/injectable.dart';

import 'auth_guard.dart';

part 'app_router.gr.dart';

@lazySingleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  final RedirectIfAuthenticatedGuard _redirectIfAuthenticatedGuard;
  final RedirectIfNotAuthenticatedGuard _redirectIfNotAuthenticatedGuard;

  AppRouter(
    this._redirectIfAuthenticatedGuard,
    this._redirectIfNotAuthenticatedGuard,
  );

  static final Duration _duration = Duration(milliseconds: 400);

  @override
  late final List<AutoRoute> routes = [
    AutoRoute(page: SplashRoute.page, initial: true),
    CustomRoute(
      page: AuthEntryRoute.page,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      duration: _duration,
      guards: [_redirectIfAuthenticatedGuard],
    ),
    CustomRoute(
      page: HomeEntryRoute.page,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      duration: _duration,
      guards: [_redirectIfNotAuthenticatedGuard],
    ),
  ];
}
