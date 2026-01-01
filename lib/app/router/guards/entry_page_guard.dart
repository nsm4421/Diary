part of '../app_router.dart';

class _EntryPagesGuard extends AutoRouteGuard {
  final AppAuthBloc _appAuthBloc;

  _EntryPagesGuard(this._appAuthBloc);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (_appAuthBloc.state.isAuth) {
      resolver.next(true);
    } else {
      router.replaceAll([const AuthRoute()]);
    }
  }
}
