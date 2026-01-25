import 'package:auto_route/auto_route.dart';
import 'package:diary/components/page_not_found.dart';
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
        AutoRoute(path: 'settings', page: SettingEntryRoute.page),
        AutoRoute(
          path: 'profile-edit',
          page: EditProfileRoute.page,
          guards: [_authenticatedOnlyGuard],
        ),
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
      path: '/vote',
      page: VoteRoute.page,
      children: [
        AutoRoute(
          path: 'create',
          page: CreateAgendaRoute.page,
          guards: [_authenticatedOnlyGuard],
        ),
        AutoRoute(path: 'comment', page: DisplayAgendaCommentRoute.page),
      ],
    ),

    /// setting
    AutoRoute(
      path: '/setting',
      page: SettingRoute.page,
      children: [
        AutoRoute(
          path: 'edit-profile',
          page: EditProfileRoute.page,
          guards: [_authenticatedOnlyGuard],
        ),
      ],
    ),
  ];
}
