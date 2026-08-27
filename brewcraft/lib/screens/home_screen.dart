import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/coffee_data.dart';
import '../models/coffee.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_bottom_nav.dart';
import '../widgets/coffee_card.dart';
import 'cart_screen.dart';
import 'coffee_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CoffeeCategory? _selectedCategory;
  int _navIndex = 0;

  List<Coffee> get _filtered => _selectedCategory == null
      ? coffeeMenu
      : coffeeMenu.where((c) => c.category == _selectedCategory).toList();

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(cart),
            const SizedBox(height: 8),
            _buildCategoryChips(),
            const SizedBox(height: 4),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                itemCount: _filtered.length,
                itemBuilder: (context, index) {
                  final coffee = _filtered[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: CoffeeCard(
                      coffee: coffee,
                      index: index,
                      onTap: () => Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: AppDurations.medium,
                          pageBuilder: (_, anim, _) =>
                              CoffeeDetailScreen(coffee: coffee),
                          transitionsBuilder: (_, anim, _, child) {
                            final curved = CurvedAnimation(
                              parent: anim,
                              curve: AppCurves.emphasized,
                            );
                            return FadeTransition(
                              opacity: curved,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.08),
                                  end: Offset.zero,
                                ).animate(curved),
                                child: child,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedBottomNav(
        items: const [
          NavItemData(Icons.local_cafe_rounded, 'Menu'),
          NavItemData(Icons.shopping_bag_rounded, 'Cart'),
          NavItemData(Icons.receipt_long_rounded, 'Orders'),
          NavItemData(Icons.person_rounded, 'Profile'),
        ],
        selectedIndex: _navIndex,
        onSelected: (i) {
          setState(() => _navIndex = i);
          if (i == 1) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const CartScreen()))
                .then((_) => setState(() => _navIndex = 0));
          }
        },
      ),
    );
  }

  Widget _buildHeader(CartProvider cart) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good morning ☀',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'What are you\nbrewing today?',
                  style: TextStyle(
                    color: AppColors.cream,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const CartScreen())),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.shopping_bag_rounded,
                      color: AppColors.cream, size: 22),
                ),
                if (cart.totalCount > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: AnimatedScale(
                      scale: 1.0,
                      duration: AppDurations.fast,
                      curve: AppCurves.overshoot,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${cart.totalCount}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = [null, ...CoffeeCategory.values];
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: categories.length,
        itemBuilder: (context, i) {
          final cat = categories[i];
          final selected = cat == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: AnimatedContainer(
                duration: AppDurations.medium,
                curve: AppCurves.overshoot,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  gradient: selected ? AppColors.accentGradient : null,
                  color: selected ? null : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  cat?.label ?? 'All',
                  style: TextStyle(
                    color: selected ? Colors.black : AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
