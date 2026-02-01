part of 'p_vote_entry.dart';

class _FilterChips extends StatelessWidget {
  const _FilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: const [
          _FilterChip(label: '최신', selected: true),
          SizedBox(width: 8),
          _FilterChip(label: '인기', selected: false),
          SizedBox(width: 8),
          _FilterChip(label: '내가 만든', selected: false),
          SizedBox(width: 8),
          _FilterChip(label: '댓글 많은 순', selected: false),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _FilterChip({
    super.key,
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {},
    );
  }
}
