import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../pages/auth/p_auth.dart';
import '../pages/home/p_home.dart';
import '../pages/splash/p_splash.dart';
import '../../features/auth/auth.dart';
import '../../features/vote/vote.dart';

part 'app_router.gr.dart';

part 'guards/auth_page_guard.dart';

part 'guards/entry_page_guard.dart';

part 'transition.dart';

@lazySingleton
@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  final AppAuthBloc _appAuthBloc;

  AppRouter(this._appAuthBloc);

  @override
  List<AutoRoute> get routes => [
    /// splash page
    AutoRoute(path: '/splash', page: SplashRoute.page, initial: true),

    /// 인증 페이지 - 인증되지 않은 경우
    AutoRoute(
      path: '/auth',
      page: AuthRoute.page,
      guards: [_AuthPagesGuard(_appAuthBloc)],
      children: [
        RedirectRoute(path: '', redirectTo: 'sign-in'),
        AutoRoute(path: 'sign-in', page: SignInRoute.page),
        CustomRoute(
          path: 'sign-up',
          page: SignUpRoute.page,
          transitionsBuilder: _rightToLeftBuilder,
        ),
      ],
    ),

    /// 시작 페이지 - 인증 성공한 경우
    AutoRoute(
      path: '/home',
      page: HomeRoute.page,
      guards: [_EntryPagesGuard(_appAuthBloc)],
      children: [
        RedirectRoute(path: '', redirectTo: 'display-agendas'),
        AutoRoute(path: 'display-agendas', page: DisplayAgendasRoute.page),
        AutoRoute(path: 'create-agendas', page: CreateAgendaRoute.page),
        CustomRoute(
          path: 'agenda-detail',
          page: AgendaDetailRoute.page,
          transitionsBuilder: _rightToLeftBuilder,
        ),
      ],
    ),
  ];
}
