import 'package:auto_route/auto_route.dart';
import 'package:diary/components/app_logo.dart';
import 'package:diary/components/loading_overlay.dart';
import 'package:diary/core/core.dart';
import 'package:diary/providers/auth/sign_up/cubit.dart';
import 'package:diary/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 's_sign_up.dart';

part 'f_form.dart';

part 'w_submit_button.dart';

@RoutePage()
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<SignUpCubit>(),
      child: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state.status.isSuccess) {
            ToastUtil.success('회원가입 성공!');
            context.router.replace(EntryRoute());
          } else if (state.status.isError) {
            ToastUtil.error(state.failure?.message ?? 'error occurs');
            context.read<SignUpCubit>().resetStatus();
          }
        },
        builder: (context, state) {
          return LoadingOverlay(
            isLoading: state.status.isLoading || state.status.isSuccess,
            child: _Screen(),
          );
        },
      ),
    );
  }
}
