import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Draws 3 procedural steam wisps as bezier ribbons that drift upward and
/// sway sideways, fading out near the top. [progress] loops 0..1.
class SteamPainter extends CustomPainter {
  final double progress;
  final Color color;

  SteamPainter({required this.progress, this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final strands = [
      _StrandConfig(xFactor: 0.28, delay: 0.0, swayScale: 1.0),
      _StrandConfig(xFactor: 0.52, delay: 0.35, swayScale: 1.3),
      _StrandConfig(xFactor: 0.74, delay: 0.6, swayScale: 0.85),
    ];

    for (final strand in strands) {
      final t = (progress + strand.delay) % 1.0;
      _drawStrand(canvas, size, strand, t);
    }
  }

  void _drawStrand(Canvas canvas, Size size, _StrandConfig strand, double t) {
    final opacity = (math.sin(t * math.pi)).clamp(0.0, 1.0) * 0.55;
    if (opacity <= 0.01) return;

    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;

    final startX = size.width * strand.xFactor;
    final startY = size.height * (1 - t * 0.95);
    final sway = 14 * strand.swayScale;

    final path = Path()..moveTo(startX, size.height);
    path.cubicTo(
      startX + sway * math.sin(t * 6),
      size.height - size.height * 0.35,
      startX - sway * math.sin(t * 5 + 1),
      size.height - size.height * 0.65,
      startX + sway * 0.4 * math.sin(t * 8),
      startY,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SteamPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

class _StrandConfig {
  final double xFactor;
  final double delay;
  final double swayScale;
  const _StrandConfig({
    required this.xFactor,
    required this.delay,
    required this.swayScale,
  });
}
