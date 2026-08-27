import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A drag-to-confirm control, the "swipe to order" gesture seen in premium
/// food & beverage apps: the user drags the knob across a pill-shaped track.
/// Releasing past ~68% completes the action, the knob snaps to the end,
/// the label flashes a success state, then everything resets.
class SlideToOrderButton extends StatefulWidget {
  final String label;
  final String successLabel;
  final String priceLabel;
  final VoidCallback onConfirmed;
  final Gradient? fillGradient;
  final double height;

  const SlideToOrderButton({
    super.key,
    required this.onConfirmed,
    this.label = 'Slide to Order',
    this.successLabel = 'Added to cart',
    this.priceLabel = '',
    this.fillGradient,
    this.height = 58,
  });

  @override
  State<SlideToOrderButton> createState() => _SlideToOrderButtonState();
}

class _SlideToOrderButtonState extends State<SlideToOrderButton> {
  double _dragExtent = 0; // 0..1
  bool _dragging = false;
  bool _completed = false;

  void _reset() {
    if (!mounted) return;
    setState(() {
      _completed = false;
      _dragExtent = 0;
    });
  }

  void _complete() {
    setState(() {
      _dragExtent = 1.0;
      _completed = true;
    });
    widget.onConfirmed();
    Future.delayed(const Duration(milliseconds: 1300), _reset);
  }

  @override
  Widget build(BuildContext context) {
    final gradient = widget.fillGradient ?? AppColors.accentGradient;

    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        final knobSize = widget.height - 8;
        final maxExtent = (trackWidth - knobSize - 8).clamp(1.0, double.infinity);
        final knobLeft = 4 + _dragExtent * maxExtent;

        return GestureDetector(
          onHorizontalDragStart: _completed
              ? null
              : (_) => setState(() => _dragging = true),
          onHorizontalDragUpdate: _completed
              ? null
              : (details) {
                  setState(() {
                    _dragExtent =
                        (_dragExtent + details.delta.dx / maxExtent).clamp(0.0, 1.0);
                  });
                },
          onHorizontalDragEnd: _completed
              ? null
              : (_) {
                  setState(() => _dragging = false);
                  if (_dragExtent > 0.68) {
                    _complete();
                  } else {
                    setState(() => _dragExtent = 0);
                  }
                },
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(widget.height / 2),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                AnimatedContainer(
                  duration: _dragging ? Duration.zero : AppDurations.medium,
                  curve: Curves.easeOut,
                  width: knobLeft + knobSize + 4,
                  height: widget.height,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(widget.height / 2),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: AnimatedOpacity(
                      duration: AppDurations.fast,
                      opacity: _dragExtent > 0.45 ? 0 : 1,
                      child: Text(
                        widget.priceLabel.isEmpty
                            ? widget.label
                            : '${widget.label}   ·   ${widget.priceLabel}',
                        style: const TextStyle(
                          color: AppColors.cream,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: AnimatedOpacity(
                      duration: AppDurations.fast,
                      opacity: _completed ? 1 : 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              color: Colors.black, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            widget.successLabel,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: _dragging ? Duration.zero : AppDurations.medium,
                  curve: Curves.easeOut,
                  margin: EdgeInsets.only(left: knobLeft),
                  width: knobSize,
                  height: knobSize,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _completed
                        ? Icons.check_rounded
                        : Icons.arrow_forward_rounded,
                    color: AppColors.accent,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
