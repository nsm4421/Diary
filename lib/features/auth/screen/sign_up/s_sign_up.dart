import 'package:auto_route/auto_route.dart';
import 'package:diary/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../provider/sign_up/sign_up_cubit.dart';
import '../../util/validation/user_info_validation_util.dart';

part 'f_form.dart';

part 'w_submit_button.dart';

@RoutePage()
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<SignUpCubit>(),
      child: Scaffold(
        appBar: AppBar(title: Text("SIGN UP")),
        body: SingleChildScrollView(
          child: Column(children: [_Form(), _SubmitButton()]),
        ),
      ),
    );
  }
}
