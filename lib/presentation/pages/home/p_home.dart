import 'package:auto_route/auto_route.dart';
import 'package:diary/core/constant/bottom_nav_menu.dart';
import 'package:diary/presentation/router/app_router.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final int _createDiaryIndexIndex = HomeBottomNavMenu.createDiary.index;

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.pageView(
      routes: HomeBottomNavMenu.values
          .where((e) => e.index != _createDiaryIndexIndex)
          .map(
            (e) => switch (e) {
              HomeBottomNavMenu.displayDiaries => DisplayDiaryRoute(),
              HomeBottomNavMenu.setting => SettingsRoute(),
              HomeBottomNavMenu.createDiary => CreateDiaryRoute(),
            },
          )
          .toList(growable: false),
      animatePageTransition: true,
      builder: (context, child, _) {
        final tabsRouter = AutoTabsRouter.of(context);
        final currentIndex = tabsRouter.activeIndex >= _createDiaryIndexIndex
            ? tabsRouter.activeIndex + 1
            : tabsRouter.activeIndex;

        return Scaffold(
          extendBody: true,
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            currentIndex: currentIndex,
            onTap: (tapped) {
              if (_createDiaryIndexIndex == tapped) {
                context.router.push(const CreateDiaryRoute());
                return;
              }
              final targetIndex = tapped > _createDiaryIndexIndex
                  ? tapped - 1
                  : tapped;
              if (targetIndex == tabsRouter.activeIndex) return;

              tabsRouter.setActiveIndex(targetIndex);
            },
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
            items: HomeBottomNavMenu.values
                .map(
                  (e) => BottomNavigationBarItem(
                    icon: Icon(e.iconData),
                    activeIcon: Icon(e.activeIconData),
                    label: e.label,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
