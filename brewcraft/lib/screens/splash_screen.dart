import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_coffee_cup.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _textController;
  late final Animation<double> _textFade;

  @override
  void initState() {
    super.initState();
    _textController = AnimationController(
      vsync: this,
      duration: AppDurations.slow,
    );
    _textFade = CurvedAnimation(parent: _textController, curve: Curves.easeOut);

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _textController.forward();
    });

    Future.delayed(const Duration(milliseconds: 2600), _goHome);
  }

  void _goHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: AppDurations.slow,
        pageBuilder: (_, animation, _) => FadeTransition(
          opacity: animation,
          child: const HomeScreen(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AnimatedCoffeeCup(
              width: 180,
              height: 210,
              targetFill: 0.78,
              liquidColor: AppColors.coffeeBrown,
              cremaColor: AppColors.latte,
              intensity: 0.85,
              fillDuration: Duration(milliseconds: 2000),
            ),
            const SizedBox(height: 28),
            FadeTransition(
              opacity: _textFade,
              child: Column(
                children: [
                  Text(
                    'BREWCRAFT',
                    style: TextStyle(
                      color: AppColors.cream,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'crafted, one cup at a time',
                    style: TextStyle(
                      color: AppColors.textMuted.withValues(alpha: 0.9),
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
