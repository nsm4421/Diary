import 'package:auto_route/auto_route.dart';
import 'package:diary/presentation/provider/home_bottom_nav/home_bottom_nav_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'bottom_nav_fragment.dart';

@RoutePage()
class HomeEntryPage extends StatelessWidget {
  const HomeEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<HomeBottomNavCubit>(),
      child: Scaffold(
        appBar: AppBar(title: Text("HOME")),
        body: SafeArea(child: Text("HOME")),
        bottomNavigationBar: const BottomNavFragment(),
      ),
    );
  }
}
