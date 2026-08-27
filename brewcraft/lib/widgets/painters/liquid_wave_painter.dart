import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Paints a cup silhouette with a liquid fill that rises to [fillLevel]
/// (0..1) and animates two out-of-phase sine waves across its surface,
/// plus a soft crema layer riding on top. Driven every frame by
/// [wavePhase] (0..2*pi, looped by an AnimationController elsewhere) so
/// the liquid always looks alive, not just filled.
class LiquidWavePainter extends CustomPainter {
  final double fillLevel; // 0..1, how full the cup is
  final double wavePhase; // radians, animates the surface ripple
  final Color liquidColor;
  final Color cremaColor;
  final double intensity; // 0..1, thickness of the crema band

  LiquidWavePainter({
    required this.fillLevel,
    required this.wavePhase,
    required this.liquidColor,
    required this.cremaColor,
    required this.intensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cupPath = _cupPath(size);
    canvas.save();
    canvas.clipPath(cupPath);

    final liquidTop = size.height * (1 - fillLevel);
    final wavePaintBack = Paint()..color = liquidColor.withValues(alpha: 0.85);
    final wavePaintFront = Paint()..color = liquidColor;

    _drawWave(
      canvas,
      size,
      baseline: liquidTop + 6,
      amplitude: 5,
      phase: wavePhase,
      paint: wavePaintBack,
    );
    _drawWave(
      canvas,
      size,
      baseline: liquidTop,
      amplitude: 6,
      phase: wavePhase + math.pi / 2,
      paint: wavePaintFront,
    );

    // Crema band: a translucent lighter strip sitting on the current
    // liquid surface, thickness scales with `intensity`.
    if (fillLevel > 0.03) {
      final cremaHeight = 10 + intensity * 10;
      final cremaRect = Rect.fromLTWH(
        0,
        liquidTop - cremaHeight * 0.4,
        size.width,
        cremaHeight,
      );
      final cremaPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [cremaColor.withValues(alpha: 0.95), cremaColor.withValues(alpha: 0.0)],
        ).createShader(cremaRect);
      canvas.drawRect(cremaRect, cremaPaint);
    }

    // Subtle inner shadow at the cup walls for depth.
    final shadowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.black.withValues(alpha: 0.18),
          Colors.transparent,
          Colors.transparent,
          Colors.black.withValues(alpha: 0.18),
        ],
        stops: const [0.0, 0.15, 0.85, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, shadowPaint);

    canvas.restore();

    // Cup outline drawn on top so the liquid reads as "inside glass".
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..color = Colors.white.withValues(alpha: 0.18);
    canvas.drawPath(cupPath, outline);
  }

  void _drawWave(
    Canvas canvas,
    Size size, {
    required double baseline,
    required double amplitude,
    required double phase,
    required Paint paint,
  }) {
    final path = Path()..moveTo(0, size.height);
    path.lineTo(0, baseline);
    const step = 6.0;
    for (double x = 0; x <= size.width; x += step) {
      final y = baseline +
          amplitude * math.sin((x / size.width * 2 * math.pi) + phase);
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  Path _cupPath(Size size) {
    // A simple rounded glass/cup silhouette used purely as a clip mask.
    final w = size.width;
    final h = size.height;
    final path = Path();
    path.moveTo(w * 0.08, 0);
    path.lineTo(w * 0.92, 0);
    path.lineTo(w * 0.82, h * 0.94);
    path.quadraticBezierTo(w * 0.5, h, w * 0.18, h * 0.94);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant LiquidWavePainter oldDelegate) {
    return oldDelegate.fillLevel != fillLevel ||
        oldDelegate.wavePhase != wavePhase ||
        oldDelegate.liquidColor != liquidColor ||
        oldDelegate.intensity != intensity;
  }
}
