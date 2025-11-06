import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

part 's_settings.dart';

part 'w_setting_title.dart';

part 'w_gradient_button.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _Screen();
  }
}