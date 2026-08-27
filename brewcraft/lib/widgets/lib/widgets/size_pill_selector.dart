import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A segmented S/M/L pill selector. The selected segment slides and takes
/// on [accentGradient] (defaults to the app's amber gradient, but callers
/// like the hero carousel pass in a gradient derived from the drink's own
/// color so every card feels individually themed).
class SizePillSelector extends StatelessWidget {
  final List<String> sizes;
  final String selected;
  final ValueChanged<String> onChanged;
  final Gradient? accentGradient;
  final double height;

  const SizePillSelector({
    super.key,
    required this.selected,
    required this.onChanged,
    this.sizes = const ['S', 'M', 'L'],
    this.accentGradient,
    this.height = 44,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = accentGradient ?? AppColors.accentGradient;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(height),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: sizes.map((size) {
          final isSelected = size == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(size),
              child: AnimatedContainer(
                duration: AppDurations.medium,
                curve: AppCurves.overshoot,
                height: height - 8,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  gradient: isSelected ? gradient : null,
                  borderRadius: BorderRadius.circular(height),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  size,
                  style: TextStyle(
                    color: isSelected ? Colors.black : AppColors.textMuted,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
