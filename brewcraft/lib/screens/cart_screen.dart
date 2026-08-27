import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import 'order_tracking_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _checkingOut = false;

  Future<void> _checkout(CartProvider cart) async {
    setState(() => _checkingOut = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: AppDurations.slow,
        pageBuilder: (_, anim, _) => FadeTransition(
          opacity: anim,
          child: const OrderTrackingScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items.values.toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Your Cart',
            style: TextStyle(color: AppColors.cream, fontWeight: FontWeight.w700)),
        iconTheme: const IconThemeData(color: AppColors.cream),
      ),
      body: items.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _CartTile(
                        key: ValueKey(item.key),
                        item: item,
                        onDismissed: () => cart.removeItem(item.key),
                        onQuantityChange: (delta) =>
                            cart.updateQuantity(item.key, delta),
                      );
                    },
                  ),
                ),
                _buildCheckoutPanel(cart),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_bag_outlined,
              color: AppColors.textMuted.withValues(alpha: 0.5), size: 64),
          const SizedBox(height: 16),
          Text('Your cart is empty',
              style: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.8))),
        ],
      ),
    );
  }

  Widget _buildCheckoutPanel(CartProvider cart) {
    return AnimatedContainer(
      duration: AppDurations.medium,
      curve: AppCurves.smooth,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _summaryRow('Subtotal', cart.subtotal),
          const SizedBox(height: 6),
          _summaryRow('Delivery', cart.deliveryFee),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.white12, height: 1),
          ),
          _summaryRow('Total', cart.total, isTotal: true),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _checkingOut ? null : () => _checkout(cart),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                elevation: 0,
              ),
              child: AnimatedSwitcher(
                duration: AppDurations.fast,
                child: _checkingOut
                    ? const SizedBox(
                        key: ValueKey('loading'),
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        'Checkout',
                        key: ValueKey('label'),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, double value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
              color: isTotal ? AppColors.cream : AppColors.textMuted,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
              fontSize: isTotal ? 16 : 13,
            )),
        AnimatedSwitcher(
          duration: AppDurations.fast,
          transitionBuilder: (child, anim) =>
              FadeTransition(opacity: anim, child: child),
          child: Text(
            '\$${value.toStringAsFixed(2)}',
            key: ValueKey(value),
            style: TextStyle(
              color: isTotal ? AppColors.accent : AppColors.textMuted,
              fontWeight: FontWeight.w700,
              fontSize: isTotal ? 18 : 13,
            ),
          ),
        ),
      ],
    );
  }
}

class _CartTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onDismissed;
  final ValueChanged<int> onQuantityChange;

  const _CartTile({
    super.key,
    required this.item,
    required this.onDismissed,
    required this.onQuantityChange,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.key),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.danger.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: item.coffee.primaryColor.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.local_cafe_rounded,
                  color: item.coffee.primaryColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.coffee.name,
                      style: const TextStyle(
                          color: AppColors.cream, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Size ${item.size}',
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
            ),
            Row(
              children: [
                _qtyButton(Icons.remove_rounded, () => onQuantityChange(-1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('${item.quantity}',
                      style: const TextStyle(
                          color: AppColors.cream, fontWeight: FontWeight.w600)),
                ),
                _qtyButton(Icons.add_rounded, () => onQuantityChange(1)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 14, color: AppColors.cream),
      ),
    );
  }
}
