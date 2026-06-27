import 'package:ditto_design/ditto_design.dart';
import 'package:flutter/material.dart';

/// Paints the star field onto a Canvas.
///
/// Stars are drawn as blurred circles with glow. Planets get a
/// larger rendering. The entire painter's opacity is controlled
/// externally via [Opacity] wrapping.
class StarFieldPainter extends CustomPainter {
  final List<ProjectedStar> stars;

  StarFieldPainter({required this.stars});

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final x = (star.x / 100) * size.width;
      final y = (star.y / 100) * size.height;
      final color = Color(star.color);
      final radius = star.size / 2;

      // Glow layer
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.4)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, star.size);
      canvas.drawCircle(Offset(x, y), radius * 2, glowPaint);

      // Core dot
      final corePaint = Paint()..color = color;
      canvas.drawCircle(Offset(x, y), radius, corePaint);
    }
  }

  @override
  bool shouldRepaint(StarFieldPainter oldDelegate) {
    return stars != oldDelegate.stars;
  }
}
