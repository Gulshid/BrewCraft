import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/coffee.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_coffee_cup.dart';

class CoffeeDetailScreen extends StatefulWidget {
  final Coffee coffee;
  const CoffeeDetailScreen({super.key, required this.coffee});

  @override
  State<CoffeeDetailScreen> createState() => _CoffeeDetailScreenState();
}

class _CoffeeDetailScreenState extends State<CoffeeDetailScreen>
    with SingleTickerProviderStateMixin {
  final _sizes = const ['S', 'M', 'L'];
  String _selectedSize = 'M';
  int _quantity = 1;

  late final AnimationController _addController;
  late final Animation<double> _addScale;

  @override
  void initState() {
    super.initState();
    _addController = AnimationController(
      vsync: this,
      duration: AppDurations.medium,
    );
    _addScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.88), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.88, end: 1.05), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _addController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  void _addToCart() {
    context
        .read<CartProvider>()
        .addToCart(widget.coffee, _selectedSize, quantity: _quantity);
    _addController.forward(from: 0);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surfaceElevated,
        duration: const Duration(milliseconds: 900),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.success),
            const SizedBox(width: 10),
            Text('${widget.coffee.name} added to cart',
                style: const TextStyle(color: AppColors.cream)),
          ],
        ),
      ),
    );
  }

  double get _fillForSize {
    switch (_selectedSize) {
      case 'S':
        return 0.55;
      case 'L':
        return 0.92;
      default:
        return 0.75;
    }
  }

  @override
  Widget build(BuildContext context) {
    final coffee = widget.coffee;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.cream, size: 18),
                  ),
                  const Spacer(),
                  Icon(Icons.favorite_border_rounded,
                      color: AppColors.textMuted.withValues(alpha: 0.8)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Hero(
                      tag: 'cup_${coffee.id}',
                      child: AnimatedCoffeeCup(
                        width: 190,
                        height: 220,
                        targetFill: _fillForSize,
                        liquidColor: coffee.primaryColor,
                        cremaColor: coffee.secondaryColor,
                        intensity: coffee.intensity,
                        fillDuration: const Duration(milliseconds: 900),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      coffee.name,
                      style: const TextStyle(
                        color: AppColors.cream,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      coffee.origin,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      coffee.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textMuted.withValues(alpha: 0.95),
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSizeSelector(),
                    const SizedBox(height: 20),
                    _buildQuantityStepper(),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: ScaleTransition(
                scale: _addScale,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _addToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadii.md),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Add to Cart',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '· \$${(coffee.price * _quantity).toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeSelector() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: _sizes.map((size) {
          final selected = size == _selectedSize;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedSize = size),
              child: AnimatedContainer(
                duration: AppDurations.medium,
                curve: AppCurves.overshoot,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: selected ? AppColors.accentGradient : null,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  size,
                  style: TextStyle(
                    color: selected ? Colors.black : AppColors.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuantityStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _stepperButton(Icons.remove_rounded, () {
          if (_quantity > 1) setState(() => _quantity--);
        }),
        const SizedBox(width: 24),
        AnimatedSwitcher(
          duration: AppDurations.fast,
          transitionBuilder: (child, anim) => ScaleTransition(
            scale: anim,
            child: child,
          ),
          child: Text(
            '$_quantity',
            key: ValueKey(_quantity),
            style: const TextStyle(
              color: AppColors.cream,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 24),
        _stepperButton(Icons.add_rounded, () => setState(() => _quantity++)),
      ],
    );
  }

  Widget _stepperButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.cream, size: 18),
      ),
    );
  }
}
