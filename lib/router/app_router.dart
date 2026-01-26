import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import 'app_router.gr.dart';
import 'auth_guard.dart';

@lazySingleton
@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter(this._guestOnlyGuard, this._authenticatedOnlyGuard);

  final GuestOnlyGuard _guestOnlyGuard;
  final AuthenticatedOnlyGuard _authenticatedOnlyGuard;

  @override
  List<AutoRoute> get routes => [
    /// splash
    AutoRoute(path: '/splash', page: SplashRoute.page, initial: true),

    /// entry
    AutoRoute(
      path: '/entry',
      page: EntryRoute.page,
      children: [
        AutoRoute(path: 'home', page: HomeRoute.page, initial: true),
        AutoRoute(path: 'display-agendas', page: DisplayAgendasRoute.page),
        AutoRoute(path: 'setting-entry', page: SettingEntryRoute.page),
      ],
    ),

    /// auth
    AutoRoute(
      path: '/auth',
      page: AuthRoute.page,
      guards: [_guestOnlyGuard],
      children: [
        RedirectRoute(path: '', redirectTo: 'sign-in'),
        AutoRoute(path: 'sign-in', page: SignInRoute.page),
        AutoRoute(path: 'sign-up', page: SignUpRoute.page),
      ],
    ),

    /// vote
    AutoRoute(
      path: '/vote/create',
      page: CreateAgendaRoute.page,
      guards: [_authenticatedOnlyGuard],
    ),
    AutoRoute(
      path: '/vote/display-comment',
      page: DisplayAgendaCommentRoute.page,
      guards: [_authenticatedOnlyGuard],
    ),

    /// account
    AutoRoute(
      path: '/account/edit',
      page: EditProfileRoute.page,
      guards: [_authenticatedOnlyGuard],
    ),
    AutoRoute(
      path: '/account/delete',
      page: DeleteAccountRoute.page,
      guards: [_authenticatedOnlyGuard],
    ),
  ];
}
