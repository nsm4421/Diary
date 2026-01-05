part of 'app_router.dart';

typedef _TransitionBuilder =
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    )?;

_TransitionBuilder _leftToRightBuilder =
    (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1.0, 0.0), // left to right
          end: Offset.zero,
        ).animate(curved),
        child: child,
      );
    };


_TransitionBuilder _rightToLeftBuilder =
    (context, animation, secondaryAnimation, child) {
  final curved = CurvedAnimation(
    parent: animation,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1.0, 0.0), // left to right
      end: Offset.zero,
    ).animate(curved),
    child: child,
  );
};
