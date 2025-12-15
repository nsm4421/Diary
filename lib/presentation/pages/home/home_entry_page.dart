import 'package:auto_route/auto_route.dart';
import 'package:diary/core/constant/home_bottom_nav.dart';
import 'package:diary/presentation/router/app_router.dart';
import 'package:flutter/material.dart';

part 'home_bottom_nav_extension.dart';

@RoutePage()
class HomeEntryPage extends StatelessWidget {
  const HomeEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: HomeBottomNav.values.map((e) => e.pageInfo).toList(),
      builder: (context, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: AutoTabsRouter.of(context).activeIndex,
            onTap: AutoTabsRouter.of(context).setActiveIndex,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            elevation: 0,
            items: HomeBottomNav.values
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
