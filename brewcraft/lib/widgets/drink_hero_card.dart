import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/coffee.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import 'animated_coffee_cup.dart';
import 'size_pill_selector.dart';
import 'slide_to_order_button.dart';

/// A full-bleed, individually-themed product card for the home screen's
/// hero carousel. Every card takes on a gradient wash of the drink's own
/// color, so swiping between them feels like the background is morphing —
/// the signature touch from the reference design.
class DrinkHeroCard extends StatefulWidget {
  final Coffee coffee;
  final VoidCallback onViewDetails;

  const DrinkHeroCard({
    super.key,
    required this.coffee,
    required this.onViewDetails,
  });

  @override
  State<DrinkHeroCard> createState() => _DrinkHeroCardState();
}

class _DrinkHeroCardState extends State<DrinkHeroCard> {
  String _size = 'M';

  double get _sizeMultiplier {
    switch (_size) {
      case 'S':
        return 0.9;
      case 'L':
        return 1.35;
      default:
        return 1.1;
    }
  }

  double get _fillForSize {
    switch (_size) {
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
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        coffee.primaryColor,
        coffee.secondaryColor,
      ],
    );

    return GestureDetector(
      onTap: widget.onViewDetails,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.xl),
          border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
          boxShadow: [
            BoxShadow(
              color: coffee.primaryColor.withValues(alpha: 0.28),
              blurRadius: 30,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Ambient color wash unique to this drink, fading into the
            // app's dark surface so text stays readable.
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    coffee.secondaryColor.withValues(alpha: 0.55),
                    AppColors.surface,
                    AppColors.surface,
                  ],
                  stops: const [0, 0.55, 1],
                ),
              ),
            ),
            Positioned(
              top: -60,
              right: -40,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: coffee.primaryColor.withValues(alpha: 0.35),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.28),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          coffee.category.label,
                          style: const TextStyle(
                            color: AppColors.cream,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star_rounded,
                          color: AppColors.accent, size: 16),
                      const SizedBox(width: 3),
                      Text(
                        coffee.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: AppColors.cream,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: Hero(
                        tag: 'cup_${coffee.id}',
                        child: AnimatedCoffeeCup(
                          width: 150,
                          height: 190,
                          targetFill: _fillForSize,
                          liquidColor: coffee.primaryColor,
                          cremaColor: coffee.secondaryColor,
                          intensity: coffee.intensity,
                          showStraw: coffee.category == CoffeeCategory.cold ||
                              coffee.category == CoffeeCategory.specialty,
                          fillDuration: const Duration(milliseconds: 900),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    coffee.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.cream,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    coffee.origin,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.cream.withValues(alpha: 0.65),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizePillSelector(
                    selected: _size,
                    onChanged: (s) => setState(() => _size = s),
                    accentGradient: gradient,
                  ),
                  const SizedBox(height: 14),
                  SlideToOrderButton(
                    priceLabel:
                        '\$${(coffee.price * _sizeMultiplier).toStringAsFixed(2)}',
                    fillGradient: gradient,
                    onConfirmed: () {
                      context
                          .read<CartProvider>()
                          .addToCart(coffee, _size, quantity: 1);
                    },
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
