import 'package:auto_route/auto_route.dart';
import 'package:diary/providers/authentication/bloc.dart';
import 'package:injectable/injectable.dart';

import 'app_router.gr.dart';

@lazySingleton
class GuestOnlyGuard extends AutoRouteGuard {
  final AuthenticationBloc _authenticationBloc;

  GuestOnlyGuard(this._authenticationBloc);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final isAuth = await _authenticationBloc.resolveIsAuth();
    if (isAuth) {
      resolver.next(true);
    } else {
      router.root.push(const EntryRoute());
      resolver.next(false);
    }
  }
}

@lazySingleton
class AuthenticatedOnlyGuard extends AutoRouteGuard {
  final AuthenticationBloc _authenticationBloc;

  AuthenticatedOnlyGuard(this._authenticationBloc);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final isAuth = await _authenticationBloc.resolveIsAuth();
    if (isAuth) {
      resolver.next(true);
    } else {
      router.root.push(const AuthRoute());
      resolver.next(false);
    }
  }
}
