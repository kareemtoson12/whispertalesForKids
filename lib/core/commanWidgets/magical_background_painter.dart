import 'dart:math';
import 'package:flutter/material.dart';

class MagicalBackgroundPainter extends CustomPainter {
  final Animation<double> animation;
  final List<Offset> cloudPositions;
  final List<double> cloudRadii;
  final List<Offset> sparklePositions;
  final List<double> sparkleRadii;

  MagicalBackgroundPainter({
    required this.animation,
    required this.cloudPositions,
    required this.cloudRadii,
    required this.sparklePositions,
    required this.sparkleRadii,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..style = PaintingStyle.fill;

    for (var i = 0; i < cloudPositions.length; i++) {
      final base = cloudPositions[i];
      final radius = cloudRadii[i];
      final x = (base.dx + animation.value * 10) % size.width;
      final y = base.dy;
      final path =
          Path()
            ..moveTo(x, y)
            ..quadraticBezierTo(
              x + radius,
              y - radius / 2 + sin(animation.value * pi * 0.5 + i) * 5,
              x + radius * 2,
              y,
            );
      canvas.drawPath(path, paint);
    }

    for (var i = 0; i < sparklePositions.length; i++) {
      final base = sparklePositions[i];
      final radius = sparkleRadii[i];
      final x = base.dx;
      final y = (base.dy + animation.value * 15) % size.height;
      paint.color = Colors.white.withOpacity(
        (0.3 + sin(animation.value * pi * 0.5 + i) * 0.2).clamp(0.0, 1.0),
      );
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
