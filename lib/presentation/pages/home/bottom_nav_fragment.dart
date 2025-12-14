part of 'home_entry_page.dart';

class BottomNavFragment extends StatelessWidget {
  const BottomNavFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBottomNavCubit, HomeBottomNav>(
      buildWhen: (prev, curr) => prev.index != curr.index,
      builder: (context, current) {
        return BottomNavigationBar(
          showSelectedLabels: true,
          showUnselectedLabels: false,
          onTap: context.read<HomeBottomNavCubit>().switchByIndex,
          currentIndex: HomeBottomNav.values.indexOf(current),
          elevation: 0,
          items: HomeBottomNav.values
              .map(
                (item) => BottomNavigationBarItem(
                  icon: Icon(item.iconData),
                  activeIcon: Icon(item.activeIconData),
                  label: item.label,
                ),
              )
              .toList(),
        );
      },
    );
  }
}
