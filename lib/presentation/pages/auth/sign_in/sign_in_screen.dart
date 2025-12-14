part of 'sign_in_page.dart';

class _SignInScreen extends StatelessWidget {
  const _SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 76,
        titleSpacing: 0,
        leadingWidth: 64,
        title: Row(
          children: [
            const AuthLogo.compact(),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Login',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => context.router.maybePop(),
            icon: const Icon(Icons.clear),
            tooltip: 'Back',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            8,
            4,
            8,
            12 + MediaQuery.of(context).viewInsets.bottom,
          ),
          physics: const BouncingScrollPhysics(),
          child: _SignInFormFragment(),
        ),
      ),
    );
  }
}
