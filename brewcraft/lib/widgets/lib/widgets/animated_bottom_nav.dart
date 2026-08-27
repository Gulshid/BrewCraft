import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NavItemData {
  final IconData icon;
  final String label;
  const NavItemData(this.icon, this.label);
}

/// Bottom nav with a pill-shaped indicator that slides and resizes to the
/// selected item using an implicit [AnimatedAlign] + [AnimatedContainer],
/// plus a small bounce on the active icon.
class AnimatedBottomNav extends StatelessWidget {
  final List<NavItemData> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const AnimatedBottomNav({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final selected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(i),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: AppDurations.medium,
                curve: AppCurves.overshoot,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  gradient: selected ? AppColors.accentGradient : null,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedScale(
                      scale: selected ? 1.15 : 1.0,
                      duration: AppDurations.fast,
                      curve: Curves.easeOut,
                      child: Icon(
                        items[i].icon,
                        color: selected ? Colors.black : AppColors.textMuted,
                        size: 22,
                      ),
                    ),
                    AnimatedDefaultTextStyle(
                      duration: AppDurations.fast,
                      style: TextStyle(
                        fontSize: selected ? 11 : 0,
                        height: selected ? 1.6 : 0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      child: Text(selected ? items[i].label : ''),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
