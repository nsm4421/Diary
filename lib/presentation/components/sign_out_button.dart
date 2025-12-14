import 'package:diary/presentation/provider/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignOutIconButton extends StatelessWidget {
  const SignOutIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return IconButton(
          onPressed: state.isProcessed
              ? () {
                  context.read<AuthBloc>().add(AuthEvent.signOut());
                }
              : null,
          icon: Icon(Icons.logout),
        );
      },
    );
  }
}
