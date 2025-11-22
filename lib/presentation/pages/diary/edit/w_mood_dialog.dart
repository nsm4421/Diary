part of 'p_edit_diary.dart';

class _MoodDialog extends StatefulWidget {
  const _MoodDialog(this._initialMood, {super.key});

  final DiaryMood _initialMood;

  @override
  State<_MoodDialog> createState() => _MoodDialogState();
}

class _MoodDialogState extends State<_MoodDialog> {
  late DiaryMood _currentMood;

  @override
  void initState() {
    super.initState();
    _currentMood = widget._initialMood;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        context.router.maybePop<DiaryMood>(_currentMood);
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colorScheme.onSurface.withAlpha(36),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '오늘 기분을 골라주세요',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '이모지를 눌러서 기분을 기록할 수 있어요.',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),

              ListView.builder(
                shrinkWrap: true,
                itemCount: DiaryMood.values.length,
                itemBuilder: (context, index) {
                  final mood = DiaryMood.values[index];
                  final isSelected = _currentMood == mood;
                  final accent = context.colorScheme.primary;
                  return ListTile(
                    leading: Icon(mood.meta.icons, color: accent),
                    onTap: () {
                      setState(() {
                        _currentMood = mood;
                      });
                    },
                    title: Text(mood.meta.label),
                    subtitle: Text(mood.meta.hint),
                    trailing: isSelected
                        ? Icon(Icons.check_circle_outline)
                        : Icon(Icons.circle_outlined),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
