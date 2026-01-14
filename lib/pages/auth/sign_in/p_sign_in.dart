import 'package:auto_route/auto_route.dart';
import 'package:diary/components/app_logo.dart';
import 'package:diary/core/core.dart';
import 'package:diary/providers/sign_in/cubit.dart';
import 'package:diary/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 's_sign_in.dart';
part 'f_form.dart';
part 'w_submit_button.dart';
part 'w_sign_up_button.dart';

@RoutePage()
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<SignInCubit>(),
      child: _Screen(),
    );
  }
}
