part of 'p_agenda_detail.dart';

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
