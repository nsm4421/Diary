part of 'p_sign_in.dart';

class _Screen extends StatelessWidget {
  const _Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("로그인")),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final shortestSide = constraints.biggest.shortestSide;
            final contentPadding = shortestSide * 0.06;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                contentPadding,
                16,
                contentPadding,
                28,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 4),
                      const AppLogo(logoSize: 48),
                      const SizedBox(height: 20),
                      Text(
                        "다시 만나서 반가워요",
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "기록을 이어가려면 로그인하세요",
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      _Form(),
                      const SizedBox(height: 12),
                      _SubmitButton(),
                      const SizedBox(height: 6),
                      _SignUpButton(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
