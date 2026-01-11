part of '../app_router.dart';

class _AuthPagesGuard extends AutoRouteGuard {
  final AppAuthBloc _appAuthBloc;

  _AuthPagesGuard(this._appAuthBloc);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (_appAuthBloc.state.isAuth) {
      router.replaceAll([const HomeRoute()]);
    } else {
      resolver.next(true);
    }
  }
}
