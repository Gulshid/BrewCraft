import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_coffee_cup.dart';
import '../widgets/painters/route_painter.dart';
import 'home_screen.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen>
    with SingleTickerProviderStateMixin {
  final _stages = const [
    ('Order Placed', Icons.receipt_long_rounded),
    ('Brewing', Icons.local_cafe_rounded),
    ('Quality Check', Icons.verified_rounded),
    ('On the way', Icons.delivery_dining_rounded),
    ('Delivered', Icons.home_rounded),
  ];

  int _currentStage = 0;
  late final AnimationController _routeController;

  @override
  void initState() {
    super.initState();
    _routeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..forward();
    _advanceStages();
  }

  Future<void> _advanceStages() async {
    for (int i = 1; i < _stages.length; i++) {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;
      setState(() => _currentStage = i);
    }
    if (mounted) {
      context.read<CartProvider>().clearCart();
    }
  }

  @override
  void dispose() {
    _routeController.dispose();
    super.dispose();
  }

  double get _brewFill =>
      (0.15 + (_currentStage / (_stages.length - 1)) * 0.8).clamp(0.0, 0.95);

  @override
  Widget build(BuildContext context) {
    final progress = _currentStage / (_stages.length - 1);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Text(
              'Tracking Your Order',
              style: TextStyle(
                color: AppColors.cream,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            AnimatedCoffeeCup(
              width: 160,
              height: 190,
              targetFill: _brewFill,
              liquidColor: AppColors.coffeeBrown,
              cremaColor: AppColors.latte,
              intensity: 0.8,
              showSteam: _currentStage <= 1,
              fillDuration: const Duration(milliseconds: 1200),
            ),
            const SizedBox(height: 8),
            AnimatedSwitcher(
              duration: AppDurations.medium,
              child: Text(
                _stages[_currentStage].$1,
                key: ValueKey(_currentStage),
                style: const TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: AnimatedBuilder(
                        animation: _routeController,
                        builder: (context, _) => CustomPaint(
                          size: const Size(24, double.infinity),
                          painter: RoutePainter(
                            progress: progress,
                            stopCount: _stages.length,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(_stages.length, (i) {
                          final done = i <= _currentStage;
                          final active = i == _currentStage;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 28),
                            child: AnimatedDefaultTextStyle(
                              duration: AppDurations.medium,
                              style: TextStyle(
                                color: done ? AppColors.cream : AppColors.textMuted,
                                fontWeight:
                                    active ? FontWeight.w700 : FontWeight.w400,
                                fontSize: active ? 16 : 14,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _stages[i].$2,
                                    size: active ? 20 : 16,
                                    color: done
                                        ? AppColors.accent
                                        : AppColors.textMuted.withValues(alpha: 0.5),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(_stages[i].$1),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: AnimatedOpacity(
                duration: AppDurations.medium,
                opacity: _currentStage == _stages.length - 1 ? 1 : 0,
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _currentStage == _stages.length - 1
                        ? () => Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (_) => const HomeScreen()),
                              (route) => false,
                            )
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadii.md),
                      ),
                    ),
                    child: const Text('Back to Menu',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
