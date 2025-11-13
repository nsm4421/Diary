import 'package:auto_route/auto_route.dart';
import 'package:diary/core/value_objects/diary.dart';
import 'package:diary/presentation/pages/diary/create/p_create_diary.dart';
import 'package:diary/presentation/pages/diary/detail/p_diary_detail.dart';
import 'package:diary/presentation/pages/diary/display/p_display_diary.dart';
import 'package:diary/presentation/pages/diary/search/result/p_searched_result.dart';
import 'package:diary/presentation/pages/security/password_gate/p_password_gate.dart';
import 'package:diary/presentation/pages/security/password_setup/p_password_setup.dart';
import 'package:diary/presentation/pages/splash/p_splash.dart';
import 'package:diary/presentation/pages/diary/search/p_search_diary.dart';
import 'package:diary/presentation/pages/settings/p_settings.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

part 'app_router.gr.dart';

@lazySingleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  static final Duration _duration = Duration(milliseconds: 400);

  @override
  late final List<AutoRoute> routes = [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: PasswordGateRoute.page),
    AutoRoute(page: DisplayDiaryRoute.page),
    CustomRoute(
      page: CreateDiaryRoute.page,
      transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
      duration: _duration,
      reverseDuration: _duration,
    ),
    CustomRoute(
      page: DiaryDetailRoute.page,
      transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
      duration: _duration,
      reverseDuration: _duration,
    ),
    AutoRoute(page: SearchDiaryRoute.page),
    CustomRoute(
      page: SearchedResultRoute.page,
      transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
      duration: _duration,
      reverseDuration: _duration,
    ),
    AutoRoute(page: SettingsRoute.page),
    AutoRoute(page: PasswordSetupRoute.page),
  ];
}
