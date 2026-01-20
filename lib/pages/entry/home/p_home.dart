import 'package:auto_route/auto_route.dart';
import 'package:diary/components/auth_icon_button.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entry'),
        actions: [LoginAndOutButton()],
      ),
      body: Text("TEST"),
    );
  }
}
