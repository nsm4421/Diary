part of 'p_edit_diary.dart';

class _MediaPreview extends StatelessWidget {
  const _MediaPreview({
    required this.file,
    required this.onRemove,
    required this.accent,
  });

  final File file;
  final VoidCallback onRemove;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: accent.withAlpha(46),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.file(file, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: -10,
          right: -10,
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.black.withAlpha(153),
              foregroundColor: Colors.white,
              minimumSize: const Size(32, 32),
              padding: EdgeInsets.zero,
            ),
            onPressed: onRemove,
            icon: const Icon(Icons.close, size: 18),
          ),
        ),
      ],
    );
  }
}
