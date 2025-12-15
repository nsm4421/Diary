import 'package:auto_route/auto_route.dart';
import 'package:diary/presentation/provider/auth/app_auth/auth_bloc.dart';
import 'package:diary/presentation/router/app_router.dart';
import 'package:injectable/injectable.dart';

abstract class _AuthGuard extends AutoRouteGuard {
  final AuthBloc _authBloc;

  _AuthGuard(this._authBloc);

  Future<void> waitUntilResolved() async {
    if (!_authBloc.state.isLoading) return;
    await _authBloc.stream.firstWhere((s) => !s.isLoading);
  }
}

/// 인증되지 않은 경우 로그인 페이지로 라우팅
@lazySingleton
class RedirectIfNotAuthenticatedGuard extends _AuthGuard {
  RedirectIfNotAuthenticatedGuard(super.authBloc);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    await waitUntilResolved();
    if (_authBloc.state.isAuth) {
      resolver.next(true);
    } else {
      router.replaceAll([const AuthEntryRoute()]);
    }
  }
}

/// 인증되어 있으면 홈화면으로 라우팅
@lazySingleton
class RedirectIfAuthenticatedGuard extends _AuthGuard {
  RedirectIfAuthenticatedGuard(super.authBloc);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    await waitUntilResolved();
    if (_authBloc.state.isAuth) {
      router.replaceAll([const HomeEntryRoute()]);
    } else {
      resolver.next(true);
    }
  }
}
