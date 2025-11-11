import 'package:auto_route/auto_route.dart';
import 'package:diary/presentation/provider/security/password_lock/password_lock_cubit.dart';
import 'package:diary/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 's_password_gate.dart';

@RoutePage()
class PasswordGatePage extends StatelessWidget {
  final bool autoRedirectToHome;
  const PasswordGatePage({super.key, this.autoRedirectToHome = false});

  @override
  Widget build(BuildContext context) {
    return _Screen(autoRedirectToHome: autoRedirectToHome);
  }
}
