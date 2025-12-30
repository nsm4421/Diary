part of 'p_splash.dart';

class _Logo extends StatefulWidget {
  const _Logo();

  @override
  State<_Logo> createState() => _LogoState();
}

class _LogoState extends State<_Logo> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  static const double _initLogoSize = 60;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: 1200.durationInMilliSec,
    );
    _scale = Tween<double>(
      begin: 0.9,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: SvgPicture.asset(
        switch (context.brightness) {
          Brightness.light => Assets.darkSplashLogoSvg.path,
          Brightness.dark => Assets.lightSplashLogoSvg.path,
        },
        width: _initLogoSize,
        height: _initLogoSize,
      ),
    );
  }
}
