part of 'p_edit_profile.dart';

class _Screen extends StatelessWidget {
  const _Screen({super.key});

  String _fallbackInitial(String username) {
    final trimmed = username.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('프로필 수정')),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          final authUser = state.currentUser;
          final username = authUser?.username ?? '익명';
          final avatarUrl = authUser?.avatarUrl;

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              children: [
                _EditAvatar(
                  avatarUrl: avatarUrl,
                  fallback: _fallbackInitial(username),
                ),
                const SizedBox(height: 24),
                _EditUsername(initialUsername: username),
              ],
            ),
          );
        },
      ),
    );
  }
}
