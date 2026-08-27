import 'package:flutter/material.dart';
import 'painters/liquid_wave_painter.dart';
import 'painters/steam_painter.dart';

/// A self-contained, reusable animated coffee cup. Two independent
/// animation loops run inside a single ticker:
///  - a fast one drives the wave ripple + steam drift (continuous)
///  - a slow one drives [fillLevel] rising from 0 to [targetFill] once,
///    used for "brewing" moments (splash screen, order tracking).
class AnimatedCoffeeCup extends StatefulWidget {
  final double targetFill;
  final Color liquidColor;
  final Color cremaColor;
  final double intensity;
  final bool showSteam;
  final bool showStraw;
  final Duration fillDuration;
  final double width;
  final double height;

  const AnimatedCoffeeCup({
    super.key,
    this.targetFill = 0.72,
    this.liquidColor = const Color(0xFF6F4E37),
    this.cremaColor = const Color(0xFFD7B899),
    this.intensity = 0.7,
    this.showSteam = true,
    this.showStraw = false,
    this.fillDuration = const Duration(milliseconds: 1800),
    this.width = 220,
    this.height = 260,
  });

  @override
  State<AnimatedCoffeeCup> createState() => _AnimatedCoffeeCupState();
}

class _AnimatedCoffeeCupState extends State<AnimatedCoffeeCup>
    with TickerProviderStateMixin {
  late final AnimationController _loopController;
  late final AnimationController _fillController;
  late final Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();
    _loopController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _fillController = AnimationController(
      vsync: this,
      duration: widget.fillDuration,
    );
    _fillAnimation = CurvedAnimation(
      parent: _fillController,
      curve: Curves.easeOutCubic,
    );
    _fillController.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedCoffeeCup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetFill != widget.targetFill) {
      _fillController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _loopController.dispose();
    _fillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: Listenable.merge([_loopController, _fillAnimation]),
        builder: (context, _) {
          final fill = widget.targetFill * _fillAnimation.value;
          return Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              if (widget.showSteam)
                Positioned(
                  top: -widget.height * 0.28,
                  child: SizedBox(
                    width: widget.width,
                    height: widget.height * 0.4,
                    child: CustomPaint(
                      painter: SteamPainter(
                        progress: _loopController.value,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              CustomPaint(
                size: Size(widget.width, widget.height),
                painter: LiquidWavePainter(
                  fillLevel: fill,
                  wavePhase: _loopController.value * 6.28318,
                  liquidColor: widget.liquidColor,
                  cremaColor: widget.cremaColor,
                  intensity: widget.intensity,
                  showStraw: widget.showStraw,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
