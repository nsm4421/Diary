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
