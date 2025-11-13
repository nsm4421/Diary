import 'package:diary/core/extension/build_context_extension.dart';
import 'package:diary/core/extension/datetime_extension.dart';
import 'package:diary/domain/entity/diary_entity.dart';
import 'package:flutter/material.dart';

class DiaryPreviewCard extends StatelessWidget {
  const DiaryPreviewCard({
    super.key,
    required this.diary,
    required this.accent,
    this.onTap,
    this.onMoreTap,
  });

  final DiaryEntity diary;
  final Color accent;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final trimmedTitle = diary.title?.trim();
    final effectiveTitle = (trimmedTitle != null && trimmedTitle.isNotEmpty)
        ? trimmedTitle
        : null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                colorScheme.surface.withAlpha(245),
                colorScheme.surface.withAlpha(224),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withAlpha(46),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
            border: Border.all(color: colorScheme.onSurface.withAlpha(15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: accent.withAlpha(217),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        diary.createdAt.toLocal().yyyymmdd,
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant.withAlpha(184),
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                  if (onMoreTap != null)
                    Tooltip(
                      message: '더보기',
                      child: Material(
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: onMoreTap,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              Icons.more_vert_outlined,
                              size: 18,
                              color: accent,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (effectiveTitle != null) ...[
                const SizedBox(height: 16),
                Text(
                  effectiveTitle,
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Text(
                diary.content,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withAlpha(235),
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
