part of 's_sign_in.dart';

class _NavigationTextButton extends StatelessWidget {
  const _NavigationTextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.router.push(SignUpRoute());
      },
      child: Text('TO SIGN UP'),
    );
  }
}
