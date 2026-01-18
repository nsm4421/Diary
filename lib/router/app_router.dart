import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import 'app_router.gr.dart';

@lazySingleton
@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: '/splash', page: SplashRoute.page, initial: true),
    AutoRoute(path: '/entry', page: EntryRoute.page),
    AutoRoute(
      path: '/auth',
      page: AuthRoute.page,
      // TODO : auth guard
      children: [
        RedirectRoute(path: '', redirectTo: 'sign-in'),
        AutoRoute(path: 'sign-in', page: SignInRoute.page),
        AutoRoute(path: 'sign-up', page: SignUpRoute.page),
      ],
    ),
    AutoRoute(
      path: '/vote',
      page: VoteRoute.page,
      children: [
        RedirectRoute(path: '', redirectTo: 'display-agendas'),
        AutoRoute(
          path: 'display-agendas',
          page: DisplayAgendasRoute.page,
          initial: true,
        ),
        AutoRoute(
          path: 'create-agenda',
          page: CreateAgendaRoute.page,
          // TODO : auth guard
          guards: [],
        ),
      ],
    ),
  ];
}
