import 'package:auto_route/auto_route.dart';
import 'package:diary/presentation/router/app_router.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('HOME')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushRoute(const CreateDiaryRoute()),
        icon: const Icon(Icons.edit),
        label: const Text('새 일기'),
      ),
      body: const Center(
        child: Text('오늘의 일기를 작성해보세요.'),
      ),
    );
  }
}
