import 'package:auto_route/auto_route.dart';
import 'package:diary/router/app_router.gr.dart';
import 'package:flutter/material.dart';

part 'screen.dart';

@RoutePage()
class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _Screen();
  }
}
