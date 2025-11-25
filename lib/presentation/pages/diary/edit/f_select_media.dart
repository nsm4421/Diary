part of 'p_edit_diary.dart';

class _SelectMedia extends StatefulWidget {
  const _SelectMedia({super.key});

  @override
  State<_SelectMedia> createState() => _SelectMediaState();
}

class _SelectMediaState extends State<_SelectMedia> {
  late final ImagePicker _imagePicker;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  Future<void> _handleAddMedia() async {
    final remaining =
        maxDiaryMediaCount - context.read<EditDiaryCubit>().state.medias.length;
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

    context.read<EditDiaryCubit>().addMediaFiles(files);

    if (truncated) {
      context.showToast('이미지는 최대 $maxDiaryMediaCount장까지 선택할 수 있어요.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditDiaryCubit, EditDiaryState>(
      buildWhen: (previous, current) => previous.medias != current.medias,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: context.colorScheme.surface.withAlpha(242),
            border: Border.all(
              color: context.colorScheme.onSurface.withAlpha(13),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.photo_library_rounded,
                    color: context.colorScheme.secondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '사진',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.colorScheme.onSurface,
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
                      color: context.colorScheme.secondary.withAlpha(31),
                    ),
                    child: Text(
                      '최대 $maxDiaryMediaCount장',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (state.medias.isNotEmpty)
                    Text(
                      '${state.medias.length}/$maxDiaryMediaCount',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.colorScheme.onSurfaceVariant.withAlpha(
                          204,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ...List.generate(
                    state.medias.length,
                    (index) => _MediaPreview(
                      file: state.medias[index],
                      onRemove: () =>
                          context.read<EditDiaryCubit>().removeMediaAt(index),
                      accent: context.colorScheme.secondary,
                    ),
                  ),
                  if (maxDiaryMediaCount > state.medias.length)
                    _AddMediaTile(
                      remaining: maxDiaryMediaCount - state.medias.length,
                      onTap: state.isSubmitting ? null : _handleAddMedia,
                      accent: context.colorScheme.secondary,
                      textTheme: context.textTheme,
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
