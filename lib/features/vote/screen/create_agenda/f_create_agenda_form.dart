part of 'p_create_agenda.dart';

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: context.colorScheme.outlineVariant.withAlpha(120),
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withAlpha(16),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "투표 정보",
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "명확한 제목과 설명을 입력해주세요.",
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Title(),
                const SizedBox(height: 16),
                _Description(),
                const SizedBox(height: 20),
                Divider(
                  height: 1,
                  color: context.colorScheme.outlineVariant.withAlpha(120),
                ),
                const SizedBox(height: 16),
                _Options(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
