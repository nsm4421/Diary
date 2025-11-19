part of '../p_display_diary.dart';

class _Calendar extends StatelessWidget {
  const _Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _Header(),
        SizedBox(height: 12),
        _CalendarGrid(),
        SizedBox(height: 16),
        Expanded(child: _Preview()),
      ],
    );
  }
}
