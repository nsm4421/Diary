import 'package:diary/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.logoSize = 60});

  final double logoSize;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      switch (Theme.of(context).colorScheme.brightness) {
        Brightness.light => Assets.darkSplashLogoSvg.path,
        Brightness.dark => Assets.lightSplashLogoSvg.path,
      },
      width: logoSize,
      height: logoSize,
    );
  }
}

class AppLogoWithAnimation extends StatefulWidget {
  const AppLogoWithAnimation({super.key});

  @override
  State<AppLogoWithAnimation> createState() => AppLogoWithAnimationState();
}

class AppLogoWithAnimationState extends State<AppLogoWithAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  static const double _initLogoSize = 60;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: 1200.durationInMilliSec,
    );
    _scale = Tween<double>(
      begin: 0.9,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: AppLogo(logoSize: _initLogoSize),
    );
  }
}
