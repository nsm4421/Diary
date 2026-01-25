import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class NotFoundedPage extends StatelessWidget {
  const NotFoundedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("PAGE NOT FOUNDED")));
  }
}
