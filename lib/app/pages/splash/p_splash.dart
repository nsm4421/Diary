import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:diary/app/router/app_router.dart';
import 'package:diary/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

part 's_splash.dart';

part 'f_body.dart';

part 'w_glow_spot.dart';

part 'w_logo.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static final _routeDelay = 1500.durationInMilliSec;

  late final Timer _routeTimer;

  @override
  void initState() {
    super.initState();
    _routeTimer = Timer(_routeDelay, () async {
      if (!mounted) return;

      final isAuth = await _getIsAuth();
      if (!mounted || isAuth == null) return;

      final navigateTo = isAuth ? HomeRoute() : AuthRoute();
      await context.router.replace(navigateTo);
    });
  }

  // TODO : 인증 기능 구현 후 수정
  Future<bool?> _getIsAuth() async {
    return null;
  }

  @override
  void dispose() {
    _routeTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const _Screen();
  }
}
