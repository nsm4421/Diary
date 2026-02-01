import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:diary/components/app_logo.dart';
import 'package:diary/components/glow_spot.dart';
import 'package:diary/router/app_router.gr.dart';
import 'package:flutter/material.dart';

import 'package:diary/core/core.dart';

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
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.colorScheme.surface,
              context.colorScheme.surface,
              context.colorScheme.primary.withAlpha(31),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final shortestSide = constraints.biggest.shortestSide;
              final contentPadding = shortestSide * 0.08;

              return Stack(
                children: [
                  GlowSpot(
                    alignment: const Alignment(-0.8, -0.9),
                    color: context.colorScheme.primary.withAlpha(46),
                    size: shortestSide * 0.75,
                  ),
                  GlowSpot(
                    alignment: const Alignment(0.9, 0.8),
                    color: context.colorScheme.tertiary.withAlpha(36),
                    size: shortestSide * 0.9,
                  ),

                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: contentPadding),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppLogoWithAnimation(),
                          const SizedBox(height: 20),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withAlpha(26),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              child: Text(
                                '익명 투표',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.4,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '애매할 땐 투표',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '혼자 고민될 때\n사람들의 의견으로 결정하세요',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  height: 1.5,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
