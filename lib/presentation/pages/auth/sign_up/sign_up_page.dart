import 'package:app_extensions/export.dart';
import 'package:auto_route/auto_route.dart';
import 'package:diary/core/utils/client_validator.dart';
import 'package:diary/presentation/components/components.dart';
import 'package:diary/presentation/provider/sign_up/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'sign_up_screen.dart';

part 'sign_up_form_fragment.dart';

part 'social_sign_up_buttons_widget.dart';

@RoutePage()
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<SignUpCubit>()..initStatus(),
      child: BlocListener<SignUpCubit, SignUpState>(
        listener: (context, state) async {
          if (state.isSuccess) {
            context.showToast('Sin Up Success');
          } else if (state.isError) {
            context.showToast(state.errorMessage ?? 'Sign Up Fails');
            await Future.delayed(Duration(milliseconds: 1500), () {
              if (context.mounted) {
                context.read<SignUpCubit>().initStatus();
              }
            });
          }
        },
        child: _SignUpScreen(),
      ),
    );
  }
}
