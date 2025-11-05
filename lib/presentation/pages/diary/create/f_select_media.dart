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
    return BlocBuilder<CreateDiaryCubit, CreateDiaryState>(
      buildWhen: (previous, current) => previous.medias != current.medias,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('사진', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(width: 8),
                Text(
                  '최대 ${_maxSelectable}장',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).textTheme.bodySmall?.color?.withAlpha(70),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ...List.generate(
                  state.medias.length,
                  (index) => Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          state.medias[index],
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: -8,
                        right: -8,
                        child: IconButton.filled(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withAlpha(60),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(28, 28),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            context.read<CreateDiaryCubit>().removeMediaAt(
                              index,
                            );
                          },
                          icon: const Icon(Icons.close, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_maxSelectable > state.medias.length)
                  SizedBox(
                    width: 96,
                    height: 96,
                    child: OutlinedButton.icon(
                      onPressed: state.isSubmitting ? null : _handleAddMedia,
                      icon: const Icon(Icons.add_photo_alternate_outlined),
                      label: Text(
                        '추가 (${_maxSelectable - state.medias.length})',
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
