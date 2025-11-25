import 'package:auto_route/auto_route.dart';
import 'package:diary/core/extension/build_context_extension.dart';
import 'package:diary/presentation/provider/permission/permission_cubit.dart';
import 'package:diary/presentation/provider/security/password_lock/password_lock_cubit.dart';
import 'package:diary/presentation/provider/setting/app_setting_cubit.dart';
import 'package:diary/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 's_settings.dart';

part 'w_setting_title.dart';

part 'w_gradient_button.dart';

part 'f_dark_mode_switch.dart';

part 'f_permission.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _Screen();
  }
}
