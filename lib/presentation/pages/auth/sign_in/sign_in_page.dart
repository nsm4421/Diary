import 'package:app_extensions/export.dart';
import 'package:auto_route/auto_route.dart';
import 'package:diary/core/utils/client_validator.dart';
import 'package:diary/presentation/components/components.dart';
import 'package:diary/presentation/provider/sign_in/sign_in_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'sign_in_screen.dart';

part 'sign_in_form_fragment.dart';

@RoutePage()
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<SignInCubit>()..initStatus(),
      child: BlocListener<SignInCubit, SignInState>(
        listener: (context, state) async {
          if (state.isSuccess) {
            context.showToast('Sin In Success');
          } else if (state.isError) {
            context.showToast(state.errorMessage ?? 'Sign In Fails');
            await Future.delayed(Duration(milliseconds: 1500), () {
              if (context.mounted) {
                context.read<SignInCubit>().initStatus();
              }
            });
          }
        },
        child: _SignInScreen(),
      ),
    );
  }
}
