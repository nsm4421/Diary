import 'package:auto_route/auto_route.dart';
import 'package:diary/core/constant/bottom_nav_menu.dart';
import 'package:diary/domain/entity/diary_entity.dart';
import 'package:diary/presentation/provider/diary/display/pagination/display_diary_bloc.dart';
import 'package:diary/presentation/provider/display/display_bloc.dart';
import 'package:diary/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final int _createDiaryIndexIndex = HomeBottomNavMenu.createDiary.index;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<DisplayDiaryBloc>()..add(DisplayEvent.started()),
      child: AutoTabsRouter.pageView(
        routes: HomeBottomNavMenu.values
            .where((e) => e.index != _createDiaryIndexIndex)
            .map(
              (e) => switch (e) {
                HomeBottomNavMenu.displayDiaries => DisplayDiaryRoute(),
                HomeBottomNavMenu.setting => SettingsRoute(),
                HomeBottomNavMenu.createDiary => EditDiaryRoute(diaryId: null),
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
              onTap: (tapped) async {
                if (_createDiaryIndexIndex == tapped) {
                  // 작성된 일기는 조회화면에 업데이트
                  await context.router
                      .push<DiaryEntity>(EditDiaryRoute(diaryId: null))
                      .then((created) {
                        if (created == null || !context.mounted) return;
                        context.read<DisplayDiaryBloc>().add(
                          DisplayEvent.created(created),
                        );
                      });
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
              unselectedItemColor: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant,
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
      ),
    );
  }
}
