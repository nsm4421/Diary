import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:diary/components/app_logo.dart';
import 'package:diary/components/glow_spot.dart';
import 'package:diary/router/app_router.gr.dart';
import 'package:flutter/material.dart';

import 'package:diary/core/core.dart';

part 's_splash.dart';

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

      await context.router.replace(EntryRoute());
    });
  }

  @override
  void dispose() {
    _routeTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _Screen();
  }
}
