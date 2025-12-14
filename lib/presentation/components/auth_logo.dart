import 'package:diary/core/constant/asset_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const String authLogoHeroTag = 'auth-logo-hero';

class AuthLogo extends StatelessWidget {
  const AuthLogo({
    super.key,
    this.padding = const EdgeInsets.all(18),
    this.iconSize = 56,
    this.showShadow = true,
    this.heroEnabled = true,
  });

  const AuthLogo.compact({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    this.iconSize = 28,
    this.showShadow = false,
    this.heroEnabled = true,
  });

  final EdgeInsetsGeometry padding;
  final double iconSize;
  final bool showShadow;
  final bool heroEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final logoPath = switch (theme.brightness) {
      Brightness.light => Assets.lightAppLogoSvg.path,
      Brightness.dark => Assets.darkAppLogoSvg.path,
    };

    final logo = Container(
      padding: padding,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 12),
                ),
              ]
            : null,
      ),
      child: SvgPicture.asset(
        logoPath,
        height: iconSize,
      ),
    );

    if (!heroEnabled) return logo;

    return Hero(
      tag: authLogoHeroTag,
      child: Material(
        color: Colors.transparent,
        child: logo,
      ),
    );
  }
}
