part of 'p_create_diary.dart';

class _AddMediaButton extends StatelessWidget {
  const _AddMediaButton({
    required this.remaining,
    required this.onTap,
    required this.isDisabled,
  });

  final int remaining;
  final VoidCallback onTap;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 96,
      child: OutlinedButton.icon(
        onPressed: isDisabled ? null : onTap,
        icon: const Icon(Icons.add_photo_alternate_outlined),
        label: Text('추가 ($remaining)'),
      ),
    );
  }
}
