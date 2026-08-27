import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/coffee_data.dart';
import '../models/coffee.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_bottom_nav.dart';
import '../widgets/coffee_card.dart';
import '../widgets/drink_hero_card.dart';
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
  int _heroIndex = 0;

  late final PageController _heroController;

  final List<Coffee> _heroList = coffeeMenu;

  List<Coffee> get _filtered => _selectedCategory == null
      ? coffeeMenu
      : coffeeMenu.where((c) => c.category == _selectedCategory).toList();

  @override
  void initState() {
    super.initState();
    _heroController = PageController(viewportFraction: 0.86);
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  void _openDetail(Coffee coffee) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: AppDurations.medium,
        pageBuilder: (_, anim, __) => CoffeeDetailScreen(coffee: coffee),
        transitionsBuilder: (_, anim, __, child) {
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(cart)),
            const SliverToBoxAdapter(child: SizedBox(height: 14)),
            SliverToBoxAdapter(child: _sectionLabel('Featured for you')),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 470,
                child: PageView.builder(
                  controller: _heroController,
                  itemCount: _heroList.length,
                  onPageChanged: (i) => setState(() => _heroIndex = i),
                  itemBuilder: (context, i) {
                    return AnimatedBuilder(
                      animation: _heroController,
                      builder: (context, child) {
                        double scale = 1.0;
                        if (_heroController.position.haveDimensions) {
                          final page =
                              _heroController.page ?? _heroIndex.toDouble();
                          scale = (1 - ((page - i).abs() * 0.10)).clamp(0.90, 1.0);
                        }
                        return Transform.scale(scale: scale, child: child);
                      },
                      child: DrinkHeroCard(
                        coffee: _heroList[i],
                        onViewDetails: () => _openDetail(_heroList[i]),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(child: _buildDots()),
            const SliverToBoxAdapter(child: SizedBox(height: 22)),
            SliverToBoxAdapter(child: _sectionLabel('Full Menu')),
            const SliverToBoxAdapter(child: SizedBox(height: 4)),
            SliverToBoxAdapter(child: _buildCategoryChips()),
            const SliverToBoxAdapter(child: SizedBox(height: 4)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final coffee = _filtered[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: CoffeeCard(
                        coffee: coffee,
                        index: index,
                        onTap: () => _openDetail(coffee),
                      ),
                    );
                  },
                  childCount: _filtered.length,
                ),
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

  static Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.cream,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_heroList.length, (i) {
        final selected = i == _heroIndex;
        return AnimatedContainer(
          duration: AppDurations.medium,
          curve: AppCurves.overshoot,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: selected ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: selected ? AppColors.accent : AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
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
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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
                curve: AppCurves.smooth,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  gradient: selected ? AppColors.accentGradient : null,
                  color: selected ? null : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
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
