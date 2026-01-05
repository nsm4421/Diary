part of 's_sign_in.dart';

class _NavigationTextButton extends StatelessWidget {
  const _NavigationTextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.router.push(SignUpRoute());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Create Account'),
          SizedBox(width: 12),
          Icon(Icons.app_registration),
        ],
      ),
    );
  }
}
