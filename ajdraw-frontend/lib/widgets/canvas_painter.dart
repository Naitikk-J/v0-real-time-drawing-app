import 'package:flutter/material.dart';
import '../models/draw_point.dart';

class CanvasPainter extends CustomPainter {
  final List<DrawPoint> points;

  CanvasPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];

      final paint = Paint()
        ..color = Color(int.parse('ff${p1.color}', radix: 16))
        ..strokeWidth = p1.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      canvas.drawLine(
        Offset(p1.x, p1.y),
        Offset(p2.x, p2.y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CanvasPainter oldDelegate) {
    return oldDelegate.points.length != points.length;
  }
}
