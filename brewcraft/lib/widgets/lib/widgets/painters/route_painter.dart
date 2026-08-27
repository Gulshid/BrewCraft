import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Draws a vertical dashed route connecting order-stage nodes, with the
/// completed portion filled solid in the accent color and animated via
/// [progress] (0..1 across the whole route).
class RoutePainter extends CustomPainter {
  final double progress;
  final int stopCount;

  RoutePainter({required this.progress, required this.stopCount});

  @override
  void paint(Canvas canvas, Size size) {
    final trackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = AppColors.accent
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final top = 0.0;
    final bottom = size.height;

    canvas.drawLine(Offset(size.width / 2, top), Offset(size.width / 2, bottom), trackPaint);

    final filledY = top + (bottom - top) * progress;
    canvas.drawLine(
      Offset(size.width / 2, top),
      Offset(size.width / 2, filledY),
      fillPaint,
    );

    // Traveling glow marker.
    final markerPaint = Paint()
      ..color = AppColors.accent
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset(size.width / 2, filledY), 7, markerPaint);
    canvas.drawCircle(
      Offset(size.width / 2, filledY),
      4,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant RoutePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
