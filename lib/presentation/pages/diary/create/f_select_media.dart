part of 'p_create_diary.dart';

class _SelectMedia extends StatefulWidget {
  const _SelectMedia({super.key});

  @override
  State<_SelectMedia> createState() => _SelectMediaState();
}

class _SelectMediaState extends State<_SelectMedia> {
  late final ImagePicker _imagePicker;
  static const int _maxSelectable = 3;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  Future<void> _handleAddMedia() async {
    final remaining =
        _maxSelectable - context.read<CreateDiaryCubit>().state.medias.length;
    final selected = await showModalBottomSheet<List<XFile>>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('갤러리에서 선택'),
                subtitle: Text('최대 $remaining장 선택 가능'),
                onTap: () async {
                  final images = await _imagePicker.pickMultiImage();
                  if (!sheetContext.mounted) return;
                  Navigator.of(sheetContext).pop(images);
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('취소'),
                onTap: () => Navigator.of(sheetContext).pop(),
              ),
            ],
          ),
        );
      },
    );

    if (selected == null || selected.isEmpty) {
      return;
    }

    final truncated = selected.length > remaining;
    final files = selected
        .take(remaining)
        .map((file) => File(file.path))
        .toList(growable: false);

    if (files.isEmpty) {
      return;
    }

    context.read<CreateDiaryCubit>().addMediaFiles(files);

    if (truncated) {
      context.showToast('이미지는 최대 ${_maxSelectable}장까지 선택할 수 있어요.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<CreateDiaryCubit, CreateDiaryState>(
      buildWhen: (previous, current) => previous.medias != current.medias,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: colorScheme.surface.withAlpha(242),
            border: Border.all(color: colorScheme.onSurface.withAlpha(13)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.photo_library_rounded,
                    color: colorScheme.secondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '사진',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: colorScheme.secondary.withAlpha(31),
                    ),
                    child: Text(
                      '최대 ${_maxSelectable}장',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (state.medias.isNotEmpty)
                    Text(
                      '${state.medias.length}/$_maxSelectable',
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant.withAlpha(204),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  ...List.generate(
                    state.medias.length,
                    (index) => _MediaPreview(
                      file: state.medias[index],
                      onRemove: () =>
                          context.read<CreateDiaryCubit>().removeMediaAt(index),
                      accent: colorScheme.secondary,
                    ),
                  ),
                  if (_maxSelectable > state.medias.length)
                    _AddMediaTile(
                      remaining: _maxSelectable - state.medias.length,
                      onTap: state.isSubmitting ? null : _handleAddMedia,
                      accent: colorScheme.secondary,
                      textTheme: textTheme,
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
