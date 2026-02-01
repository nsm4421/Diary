import 'package:auth/auth.dart';
import 'package:auto_route/auto_route.dart';
import 'package:diary/components/profile_avatar.dart';
import 'package:diary/components/round_card.dart';
import 'package:diary/core/core.dart';
import 'package:diary/providers/auth/app_auth/bloc.dart';
import 'package:diary/providers/setting/theme_mode/cubit.dart';
import 'package:diary/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

part 's_setting_entry.dart';

part 's_un_auth.dart';

part 'f_profile.dart';

part 'f_account.dart';

part 'f_theme.dart';

part 'w_section_header.dart';

part 'w_appbar.dart';

@RoutePage()
class SettingEntryPage extends StatelessWidget {
  const SettingEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return state.isAuth ? _OnAuthScreen() : _OnUnAuthScreen();
      },
    );
  }
}
