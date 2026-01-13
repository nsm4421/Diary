import 'package:flutter/material.dart';

class GlowSpot extends StatelessWidget {
  const GlowSpot({super.key,
    required this.alignment,
    required this.color,
    required this.size,
  });

  final Alignment alignment;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [color, color.withAlpha(0)]),
          ),
        ),
      ),
    );
  }
}
