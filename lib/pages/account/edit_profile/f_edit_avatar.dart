part of 'p_edit_profile.dart';

class _EditAvatar extends StatefulWidget {
  const _EditAvatar({
    super.key,
    required this.avatarUrl,
    required this.fallback,
  });

  final String? avatarUrl;
  final String fallback;

  @override
  State<_EditAvatar> createState() => _EditAvatarState();
}

class _EditAvatarState extends State<_EditAvatar> {
  XFile? _localImage;

  Future<void> _handlePickLocalImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 92,
    );
    if (picked == null) return;

    setState(() {
      _localImage = picked;
    });
  }

  void _handleClearLocalImage() {
    setState(() {
      _localImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final hasLocalImage = _localImage != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '프로필 사진',
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        RoundCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AvatarPreview(
                  avatarUrl: widget.avatarUrl,
                  fallback: widget.fallback,
                  localImage: _localImage,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasLocalImage ? '로컬 이미지 미리보기' : '현재 아바타',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '저장 전까지는 변경 사항이 반영되지 않아요.',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilledButton.tonalIcon(
                            onPressed: _handlePickLocalImage,
                            icon: const Icon(Icons.photo_library_outlined),
                            label: const Text('로컬에서 선택'),
                          ),
                          if (hasLocalImage)
                            TextButton(
                              onPressed: _handleClearLocalImage,
                              child: const Text('선택 취소'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AvatarPreview extends StatelessWidget {
  const _AvatarPreview({
    required this.avatarUrl,
    required this.fallback,
    required this.localImage,
  });

  final String? avatarUrl;
  final String fallback;
  final XFile? localImage;

  @override
  Widget build(BuildContext context) {
    const double size = 88;

    if (localImage != null) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: FileImage(File(localImage!.path)),
      );
    }

    if (avatarUrl != null && avatarUrl!.trim().isNotEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: CachedNetworkImageProvider(avatarUrl!.trim()),
        backgroundColor: context.colorScheme.surfaceContainerHighest,
      );
    }

    return CircleAvatar(
      radius: size / 2,
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
