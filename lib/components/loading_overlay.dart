import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.indicator,
    this.overlayColor,
    this.alignment = Alignment.center,
  });

  final bool isLoading;
  final Widget child;
  final Widget? indicator;
  final Color? overlayColor;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return child;
    }

    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Stack(
            children: [
              ModalBarrier(
                dismissible: false,
                color: overlayColor ?? Colors.black45,
              ),
              Align(
                alignment: alignment,
                child: indicator ?? const CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
