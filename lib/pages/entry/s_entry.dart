part of 'p_entry.dart';

class _EntryTabsScreen extends StatelessWidget {
  const _EntryTabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.pageView(
      routes: const [HomeRoute(), DisplayAgendasRoute(), SettingEntryRoute()],
      animatePageTransition: true,
      physics: NeverScrollableScrollPhysics(),
      duration: 250.durationInMilliSec,
      curve: Curves.easeOutCubic,
      builder: (context, child, _) {
        final tabsRouter = AutoTabsRouter.of(context);

        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.how_to_vote_outlined),
                activeIcon: Icon(Icons.how_to_vote),
                label: 'Vote',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'Setting',
              ),
            ],
          ),
        );
      },
    );
  }
}
