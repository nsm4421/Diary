part of 'home_bottom_nav_cubit.dart';

enum HomeBottomNav { display, create, setting }

extension HomeBottomNavX on HomeBottomNav {
  String get label {
    return switch (this) {
      HomeBottomNav.display => 'HOME',
      HomeBottomNav.create => 'CREATE',
      HomeBottomNav.setting => 'SETTING',
    };
  }

  IconData get iconData {
    return switch (this) {
      HomeBottomNav.display => Icons.home_outlined,
      HomeBottomNav.create => Icons.add_circle_outline,
      HomeBottomNav.setting => Icons.settings_outlined,
    };
  }

  IconData get activeIconData {
    return switch (this) {
      HomeBottomNav.display => Icons.home,
      HomeBottomNav.create => Icons.add_circle,
      HomeBottomNav.setting => Icons.settings,
    };
  }
}
