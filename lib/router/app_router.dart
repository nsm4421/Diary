import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import 'app_router.gr.dart';
import 'auth_guard.dart';

@lazySingleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter(this._guestOnlyGuard, this._authenticatedOnlyGuard);

  final GuestOnlyGuard _guestOnlyGuard;
  final AuthenticatedOnlyGuard _authenticatedOnlyGuard;

  List<AutoRoute> get _guestOnlyRoutes => [
    RedirectRoute(path: '', redirectTo: 'sign-in'),
    AutoRoute(path: 'sign-in', page: SignInRoute.page),
    AutoRoute(path: 'sign-up', page: SignUpRoute.page),
  ];

  List<AutoRoute> get _publicRoute => [
    /// splash
    AutoRoute(path: '/splash', page: SplashRoute.page, initial: true),

    /// entry
    AutoRoute(
      path: '/entry',
      page: EntryRoute.page,
      children: [
        AutoRoute(path: 'home-entry', page: HomeEntryRoute.page, initial: true),
        AutoRoute(path: 'vote-entry', page: VoteEntryRoute.page),
        AutoRoute(path: 'setting-entry', page: SettingEntryRoute.page),
      ],
    ),
  ];

  List<AutoRoute> get _authenticatedRoute => [
    /// account
    AutoRoute(path: 'account/edit', page: EditProfileRoute.page),
    AutoRoute(path: 'account/delete', page: DeleteAccountRoute.page),

    /// vote
    AutoRoute(path: 'vote/create', page: CreateAgendaRoute.page),
    AutoRoute(
      path: 'vote/display-comment',
      page: DisplayAgendaCommentRoute.page,
    ),
    AutoRoute(path: 'vote/agenda-detail', page: AgendaDetailRoute.page),
  ];

  @override
  List<AutoRoute> get routes => [
    /// guest only
    AutoRoute(
      path: '/auth',
      page: AuthRoute.page,
      guards: [_guestOnlyGuard],
      children: _guestOnlyRoutes,
    ),

    /// public
    ..._publicRoute,

    /// authenticated
    AutoRoute(
      page: AuthenticatedRoute.page,
      guards: [_authenticatedOnlyGuard],
      children: _authenticatedRoute,
    ),
  ];
}
