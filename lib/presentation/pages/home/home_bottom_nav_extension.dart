part of 'home_entry_page.dart';

extension _HomeBottomNavX on HomeBottomNav {
  PageRouteInfo get pageInfo {
    return switch (this) {
      HomeBottomNav.display => DisplayDiariesRoute(),
      HomeBottomNav.search => SearchDiaryRoute(),
      HomeBottomNav.setting => SettingRoute(),
    };
  }

  String get label {
    return switch (this) {
      HomeBottomNav.display => 'HOME',
      HomeBottomNav.search => 'SEARCH',
      HomeBottomNav.setting => 'SETTING',
    };
  }

  IconData get iconData {
    return switch (this) {
      HomeBottomNav.display => Icons.home_outlined,
      HomeBottomNav.search => Icons.search_outlined,
      HomeBottomNav.setting => Icons.settings_outlined,
    };
  }

  IconData get activeIconData {
    return switch (this) {
      HomeBottomNav.display => Icons.home,
      HomeBottomNav.search => Icons.search,
      HomeBottomNav.setting => Icons.settings,
    };
  }
}
