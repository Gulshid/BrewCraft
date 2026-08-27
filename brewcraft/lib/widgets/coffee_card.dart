import 'package:flutter/material.dart';
import '../models/coffee.dart';
import '../theme/app_theme.dart';
import 'animated_coffee_cup.dart';

/// A menu card that:
///  - fades + slides in with a per-index stagger delay (see [index])
///  - scales down slightly with a spring on tap-down for tactile feedback
///  - participates in a Hero transition into the detail screen
class CoffeeCard extends StatefulWidget {
  final Coffee coffee;
  final int index;
  final VoidCallback onTap;

  const CoffeeCard({
    super.key,
    required this.coffee,
    required this.index,
    required this.onTap,
  });

  @override
  State<CoffeeCard> createState() => _CoffeeCardState();
}

class _CoffeeCardState extends State<CoffeeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(vsync: this, duration: AppDurations.slow);
    _fade = CurvedAnimation(parent: _entrance, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entrance, curve: AppCurves.emphasized));

    Future.delayed(Duration(milliseconds: 80 * widget.index), () {
      if (mounted) _entrance.forward();
    });
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _pressed ? 0.96 : 1.0,
            duration: AppDurations.fast,
            curve: Curves.easeOut,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(AppRadii.lg),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 64,
                    height: 76,
                    child: AnimatedCoffeeCup(
                      width: 64,
                      height: 76,
                      showSteam: false,
                      targetFill: 0.75,
                      liquidColor: widget.coffee.primaryColor,
                      cremaColor: widget.coffee.secondaryColor,
                      intensity: widget.coffee.intensity,
                      showStraw: widget.coffee.category == CoffeeCategory.cold ||
                          widget.coffee.category == CoffeeCategory.specialty,
                      fillDuration: const Duration(milliseconds: 1400),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.coffee.name,
                          style: const TextStyle(
                            color: AppColors.cream,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.coffee.origin,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: AppColors.accent, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              widget.coffee.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${widget.coffee.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          gradient: AppColors.accentGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add,
                            color: Colors.black, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
