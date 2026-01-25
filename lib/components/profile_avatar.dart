import 'package:diary/core/core.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.avatarUrl,
    this.fallback = '익명',
    this.radius = 25,
  });

  final String? avatarUrl;
  final String fallback;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (avatarUrl != null && avatarUrl!.trim().isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: context.colorScheme.surfaceContainerHighest.withAlpha(
          90,
        ),
        backgroundImage: NetworkImage(avatarUrl!),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: context.colorScheme.primary.withAlpha(20),
      child: Text(
        fallback,
        style: context.textTheme.titleMedium?.copyWith(
          color: context.colorScheme.primary,
        ),
      ),
    );
  }
}
