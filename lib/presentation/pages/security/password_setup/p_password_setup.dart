import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:diary/presentation/provider/security/password_setup/password_setup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 's_password_setup.dart';

@RoutePage()
class PasswordSetupPage extends StatelessWidget {
  const PasswordSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<PasswordSetupCubit>()..init(),
      child: const _PasswordSetupView(),
    );
  }
}
