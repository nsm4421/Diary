import 'package:flutter/material.dart';

class AppLogoHero extends StatelessWidget {
  const AppLogoHero({
    super.key,
    this.enabled = true,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    this.padding = const EdgeInsets.all(10),
    this.iconSize = 22,
    this.heroTag = 'diary-logo',
    this.iconData = Icons.auto_awesome_rounded,
  });

  final bool enabled;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final EdgeInsetsGeometry padding;
  final double iconSize;
  final String heroTag;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fillColor =
        backgroundColor ?? colorScheme.primary.withValues(alpha: 0.12);
    final outlineColor =
        borderColor ?? colorScheme.primary.withValues(alpha: 0.3);
    final resolvedIconColor = iconColor ?? colorScheme.primary;

    final logo = Container(
      padding: padding,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fillColor,
        border: Border.all(color: outlineColor, width: 1),
      ),
      child: Icon(iconData, color: resolvedIconColor, size: iconSize),
    );

    return HeroMode(
      enabled: enabled,
      child: Hero(tag: heroTag, child: logo),
    );
  }
}
