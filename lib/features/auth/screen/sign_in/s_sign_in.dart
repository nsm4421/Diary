import 'package:auto_route/auto_route.dart';
import 'package:diary/app/router/app_router.dart';
import 'package:diary/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../provider/sign_in/sign_in_cubit.dart';
import '../../util/validation/user_info_validation_util.dart';

part 'f_form.dart';

part 'w_submit_button.dart';

part 'w_navigation_text_button.dart';

@RoutePage()
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<SignInCubit>(),
      child: Scaffold(
        appBar: AppBar(title: Text('SIGN IN')),
        body: SafeArea(
          child: Column(
            children: [_Form(), _SubmitButton(), _NavigationTextButton()],
          ),
        ),
      ),
    );
  }
}
