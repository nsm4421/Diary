import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class DisplayDiariesPage extends StatelessWidget {
  const DisplayDiariesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Display Diaries"),
      ),
    );
  }
}
