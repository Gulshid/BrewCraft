import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Paints a to-go cup: a glass body with a liquid fill that rises to
/// [fillLevel] (0..1) and animates two out-of-phase sine waves across its
/// surface, a whipped-topping dome riding on the surface, a lid, and
/// (optionally) a straw — driven every frame by [wavePhase] so the drink
/// always looks alive, not just filled.
class LiquidWavePainter extends CustomPainter {
  final double fillLevel; // 0..1, how full the cup is
  final double wavePhase; // radians, animates the surface ripple
  final Color liquidColor;
  final Color cremaColor;
  final double intensity; // 0..1, thickness of the topping dome
  final bool showStraw;

  LiquidWavePainter({
    required this.fillLevel,
    required this.wavePhase,
    required this.liquidColor,
    required this.cremaColor,
    required this.intensity,
    this.showStraw = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cupPath = _cupPath(size);

    canvas.save();
    canvas.clipPath(cupPath);

    // A faint glass tint so the empty part of the cup still reads as
    // glass instead of disappearing into the background.
    final glassPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.09),
          Colors.white.withValues(alpha: 0.02),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, glassPaint);

    final liquidTop = size.height * (1 - fillLevel);
    final wavePaintBack = Paint()..color = liquidColor.withValues(alpha: 0.85);
    final liquidRect =
        Rect.fromLTWH(0, liquidTop, size.width, size.height - liquidTop);
    final wavePaintFront = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.lerp(liquidColor, Colors.white, 0.14) ?? liquidColor,
          liquidColor,
        ],
      ).createShader(liquidRect);

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

    // Whipped topping / crema dome riding on the surface.
    if (fillLevel > 0.03) {
      final domeHeight = 9 + intensity * 9;
      final domeLeft = size.width * 0.08;
      final domeRight = size.width * 0.92;
      final domeTop = liquidTop - domeHeight;
      final domeCenterX = (domeLeft + domeRight) / 2;

      final dome = Path()
        ..moveTo(domeLeft, liquidTop)
        ..quadraticBezierTo(domeLeft, domeTop, domeCenterX, domeTop)
        ..quadraticBezierTo(domeRight, domeTop, domeRight, liquidTop)
        ..close();
      final domePaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(cremaColor, Colors.white, 0.4) ?? cremaColor,
            cremaColor,
          ],
        ).createShader(Rect.fromLTRB(domeLeft, domeTop, domeRight, liquidTop));
      canvas.drawPath(dome, domePaint);

      // Soft ridge highlights for a whipped texture.
      final ridgePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = Colors.white.withValues(alpha: 0.32);
      for (final dx in [-0.16, 0.0, 0.16]) {
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(
              domeCenterX + dx * (domeRight - domeLeft),
              liquidTop - domeHeight * 0.32,
            ),
            width: (domeRight - domeLeft) * 0.3,
            height: domeHeight * 0.85,
          ),
          math.pi,
          math.pi,
          false,
          ridgePaint,
        );
      }
    }

    // Inner wall shadow for depth.
    final shadowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.black.withValues(alpha: 0.22),
          Colors.transparent,
          Colors.transparent,
          Colors.black.withValues(alpha: 0.22),
        ],
        stops: const [0.0, 0.15, 0.85, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, shadowPaint);

    canvas.restore();

    // Cup outline, tinted with the drink's own color for a premium look.
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..color =
          (Color.lerp(liquidColor, Colors.white, 0.55) ?? Colors.white)
              .withValues(alpha: 0.55);
    canvas.drawPath(cupPath, outline);

    // A glossy diagonal highlight so the body reads as glass/plastic.
    final highlight = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.10);
    canvas.drawLine(
      Offset(size.width * 0.28, size.height * 0.08),
      Offset(size.width * 0.2, size.height * 0.62),
      highlight,
    );

    _drawLid(canvas, size);
    if (showStraw) _drawStraw(canvas, size, liquidTop);
  }

  void _drawLid(Canvas canvas, Size size) {
    final lidRect = Rect.fromLTWH(
      size.width * 0.02,
      -size.height * 0.015,
      size.width * 0.96,
      size.height * 0.09,
    );
    final lidRRect = RRect.fromRectAndRadius(
      lidRect,
      Radius.circular(lidRect.height),
    );
    canvas.drawRRect(
      lidRRect,
      Paint()..color = Colors.white.withValues(alpha: 0.92),
    );
    canvas.drawRRect(
      lidRRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = Colors.black.withValues(alpha: 0.12),
    );
  }

  void _drawStraw(Canvas canvas, Size size, double liquidTop) {
    final strawX = size.width * 0.63;
    final strawWidth = size.width * 0.045;
    final strawTop = -size.height * 0.16;
    final strawBottom =
        math.min(liquidTop + size.height * 0.16, size.height * 0.88);

    final strawRRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        strawX - strawWidth / 2,
        strawTop,
        strawX + strawWidth / 2,
        strawBottom,
      ),
      Radius.circular(strawWidth / 2),
    );
    canvas.drawRRect(
      strawRRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white.withValues(alpha: 0.92),
            Colors.white.withValues(alpha: 0.55),
          ],
        ).createShader(strawRRect.outerRect),
    );
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
        oldDelegate.intensity != intensity ||
        oldDelegate.showStraw != showStraw;
  }
}
