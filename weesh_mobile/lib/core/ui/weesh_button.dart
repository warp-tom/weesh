import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weesh_mobile/core/theme/constants.dart';

/// Weesh button system with three variants:
/// - [WeeshButton.filled] — Primary CTA (terracotta)
/// - [WeeshButton.ghost] — Secondary / Cancel actions
/// - [WeeshButton.icon] — Icon + label chip button
class WeeshButton extends StatefulWidget {
  const WeeshButton.filled({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.width = double.infinity,
  })  : _variant = _ButtonVariant.filled,
        icon = null;

  const WeeshButton.ghost({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.width = double.infinity,
  })  : _variant = _ButtonVariant.ghost,
        icon = null;

  const WeeshButton.icon({
    super.key,
    required this.label,
    required this.onTap,
    required this.icon,
    this.isLoading = false,
    this.width = double.infinity,
  }) : _variant = _ButtonVariant.withIcon;

  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final double width;
  final IconData? icon;
  final _ButtonVariant _variant;

  @override
  State<WeeshButton> createState() => _WeeshButtonState();
}

class _WeeshButtonState extends State<WeeshButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: AppDurations.fast,
        width: widget.width,
        height: 56,
        transform: Matrix4.diagonal3Values(_isPressed ? 0.97 : 1.0, _isPressed ? 0.97 : 1.0, 1.0),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: AppRadius.buttonRadius,
          border: widget._variant == _ButtonVariant.ghost
              ? Border.all(color: AppColors.terracotta, width: 1.5)
              : null,
        ),
        child: widget.isLoading
            ? Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: widget._variant == _ButtonVariant.ghost
                        ? AppColors.terracotta
                        : Colors.white,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: _foregroundColor, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _foregroundColor,
                    ),
                  ),
                ],
              ),
      ),
    ).animate().fadeIn(duration: AppDurations.normal);
  }

  Color get _backgroundColor => switch (widget._variant) {
        _ButtonVariant.filled || _ButtonVariant.withIcon => AppColors.terracotta,
        _ButtonVariant.ghost => Colors.transparent,
      };

  Color get _foregroundColor => switch (widget._variant) {
        _ButtonVariant.filled || _ButtonVariant.withIcon => Colors.white,
        _ButtonVariant.ghost => AppColors.terracotta,
      };
}

enum _ButtonVariant { filled, ghost, withIcon }
