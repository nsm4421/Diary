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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ValueListenableBuilder<int>(
          valueListenable: currentPage,
          builder: (context, selected, child) {
            final clampedIndex = selected.clamp(0, medias.length - 1).toInt();
            final aspectRatio =
                _aspectRatioOf(medias[clampedIndex]) ?? _defaultAspectRatio;

            return AspectRatio(aspectRatio: aspectRatio, child: child!);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: PageView.builder(
              controller: controller,
              onPageChanged: onPageChanged,
              itemCount: medias.length,
              itemBuilder: (context, index) {
                final media = medias[index];
                final aspectRatio = _aspectRatioOf(media);
                final isLandscape = aspectRatio != null
                    ? aspectRatio >= 1
                    : true;

                return ColoredBox(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withAlpha(30),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        File(media.absolutePath),
                        fit: isLandscape ? BoxFit.cover : BoxFit.contain,
                        alignment: Alignment.center,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              size: 48,
                            ),
                          );
                        },
                      ),
                      if (media.width != null && media.height != null)
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surface.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Text(
                                '${media.width} × ${media.height}',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),

        // indicator
        if (medias.length > 1) ...[
          const SizedBox(height: 12),
          Center(
            child: ValueListenableBuilder<int>(
              valueListenable: currentPage,
              builder: (context, selected, _) {
                return Wrap(
                  spacing: 8,
                  children: List.generate(medias.length, (index) {
                    final isSelected = selected == index;
                    return GestureDetector(
                      onTap: () => onDotTapped(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                        width: isSelected ? 16 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant.withAlpha(40),
                          borderRadius: BorderRadius.circular(4),
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
