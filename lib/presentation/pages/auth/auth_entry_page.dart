import 'package:app_extensions/export.dart';
import 'package:auto_route/auto_route.dart';
import 'package:diary/presentation/components/components.dart';
import 'package:diary/presentation/pages/auth/sign_in/sign_in_page.dart';
import 'package:diary/presentation/pages/auth/sign_up/sign_up_page.dart';
import 'package:diary/presentation/provider/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AuthEntryPage extends StatelessWidget {
  const AuthEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text("AUTH"),
      ),
    );
  }
}
