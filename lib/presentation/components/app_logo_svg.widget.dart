import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLogoSvg extends StatelessWidget {
  const AppLogoSvg({super.key, this.size = 48});

  final double size;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final assetPath = brightness == Brightness.dark
        ? 'assets/svg/dark_app_logo.svg'
        : 'assets/svg/light_app_logo.svg';

    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      semanticsLabel: 'Diary logo',
    );
  }
}
