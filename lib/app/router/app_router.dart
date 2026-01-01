import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import '../pages/auth/p_auth.dart';
import '../pages/entry/entry_page.dart';
import '../pages/entry/home/home_page.dart';
import '../pages/splash/p_splash.dart';
import '../../features/auth/auth.dart';

part 'app_router.gr.dart';

part 'guards/auth_page_guard.dart';

part 'guards/entry_page_guard.dart';

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
        AutoRoute(path: 'sign-up', page: SignUpRoute.page),
      ],
    ),

    /// 시작 페이지 - 인증 성공한 경우
    AutoRoute(
      path: '/entry',
      page: EntryRoute.page,
      guards: [_EntryPagesGuard(_appAuthBloc)],
      children: [
        RedirectRoute(path: '', redirectTo: 'home'),
        AutoRoute(path: 'home', page: HomeRoute.page),
      ],
    ),
  ];
}
