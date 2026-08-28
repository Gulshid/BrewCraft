import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: AppColors.cream, size: 18),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Profile',
                  style: TextStyle(
                    color: AppColors.cream,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.accentGradient,
                    ),
                    child: const Icon(Icons.person_rounded,
                        color: Colors.black, size: 44),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Coffee Lover',
                    style: TextStyle(
                      color: AppColors.cream,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'guest@brewcraft.app',
                    style: TextStyle(
                      color: AppColors.textMuted.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.favorite_rounded,
                    label: 'Favorites',
                    value: '${favorites.count}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.shopping_bag_rounded,
                    label: 'In Cart',
                    value: '${cart.totalCount}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const _SectionLabel('Account'),
            _ProfileTile(
              icon: Icons.location_on_rounded,
              label: 'Delivery Addresses',
              onTap: () => _comingSoon(context),
            ),
            _ProfileTile(
              icon: Icons.payment_rounded,
              label: 'Payment Methods',
              onTap: () => _comingSoon(context),
            ),
            _ProfileTile(
              icon: Icons.notifications_rounded,
              label: 'Notifications',
              onTap: () => _comingSoon(context),
            ),
            const SizedBox(height: 20),
            const _SectionLabel('Support'),
            _ProfileTile(
              icon: Icons.help_outline_rounded,
              label: 'Help Center',
              onTap: () => _comingSoon(context),
            ),
            _ProfileTile(
              icon: Icons.info_outline_rounded,
              label: 'About BrewCraft',
              onTap: () => _comingSoon(context),
            ),
            const SizedBox(height: 20),
            _ProfileTile(
              icon: Icons.logout_rounded,
              label: 'Sign Out',
              danger: true,
              onTap: () => _comingSoon(context),
            ),
          ],
        ),
      ),
    );
  }

  static void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surfaceElevated,
        duration: Duration(milliseconds: 900),
        content: Text('Coming soon',
            style: TextStyle(color: AppColors.cream)),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.accent, size: 22),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.cream,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textMuted.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.textMuted.withValues(alpha: 0.7),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.danger : AppColors.cream;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          child: Row(
            children: [
              Icon(icon, color: danger ? AppColors.danger : AppColors.textMuted, size: 20),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(color: color, fontWeight: FontWeight.w600),
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: AppColors.textMuted.withValues(alpha: 0.6)),
            ],
          ),
        ),
      ),
    );
  }
}
