part of 'p_diary_detail.dart';

class _MediaCarousel extends StatelessWidget {
  const _MediaCarousel({
    required this.medias,
    required this.controller,
    required this.currentPage,
    required this.onPageChanged,
    required this.onDotTapped,
  });

  final List<DiaryMediaAsset> medias;
  final PageController controller;
  final ValueNotifier<int> currentPage;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onDotTapped;

  static const double _defaultAspectRatio = 4 / 3;

  Color _accentColor(BuildContext context) =>
      Theme.of(context).colorScheme.secondary;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ValueListenableBuilder<int>(
          valueListenable: currentPage,
          builder: (context, selected, child) {
            final clampedIndex = selected.clamp(0, medias.length - 1).toInt();
            final aspectRatio =
                _aspectRatioOf(medias[clampedIndex]) ?? _defaultAspectRatio;

            return AspectRatio(
              aspectRatio: aspectRatio,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: colorScheme.onPrimary.withAlpha(26),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _accentColor(context).withAlpha(46),
                      blurRadius: 32,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: child!,
                ),
              ),
            );
          },
          child: PageView.builder(
            controller: controller,
            onPageChanged: onPageChanged,
            itemCount: medias.length,
            itemBuilder: (context, index) {
              final media = medias[index];
              final aspectRatio = _aspectRatioOf(media);
              final isLandscape = aspectRatio != null ? aspectRatio >= 1 : true;

              return Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(
                    color: colorScheme.surfaceContainerHighest.withAlpha(61),
                    child: Image.file(
                      File(media.absolutePath),
                      fit: isLandscape ? BoxFit.cover : BoxFit.contain,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: colorScheme.onSurfaceVariant,
                            size: 48,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withAlpha(217),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colorScheme.onSurface.withAlpha(26),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.image,
                              size: 16,
                              color: _accentColor(context),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${media.width ?? '-'} × ${media.height ?? '-'}',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // indicator
        if (medias.length > 1) ...[
          const SizedBox(height: 16),
          Center(
            child: ValueListenableBuilder<int>(
              valueListenable: currentPage,
              builder: (context, selected, _) {
                final accent = _accentColor(context);
                return Wrap(
                  spacing: 8,
                  children: List.generate(medias.length, (index) {
                    final isSelected = selected == index;
                    return GestureDetector(
                      onTap: () => onDotTapped(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                        width: isSelected ? 20 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? accent
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant.withAlpha(60),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: accent.withAlpha(102),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  double? _aspectRatioOf(DiaryMediaAsset media) {
    final width = media.width;
    final height = media.height;
    if (width == null || height == null || width <= 0 || height <= 0) {
      return null;
    }
    return width / height;
  }
}
