part of 'display_diaries_page.dart';

class _DiariesListFragment extends StatelessWidget {
  const _DiariesListFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayDiariesBloc, DisplayState<DiaryEntity, DateTime>>(
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: state.items.length,
          itemBuilder: (context, index) {
            final diary = state.items[index];
            return ListTile(title: Text(diary.title ?? '무제'));
          },
        );
      },
    );
  }
}
