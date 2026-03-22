import 'package:flutter/material.dart';
import 'package:weesh_mobile/core/theme/constants.dart';

/// Canonical flat card widget for the Weesh design system.
/// Uses [AppShadows.soft] by default on a pure white background 
/// to create modern spatial depth without heavy colors or borders.
class WeeshCard extends StatelessWidget {
  const WeeshCard({
    super.key,
    required this.child,
    this.color,
    this.padding,
    this.borderColor,
    this.borderRadius,
    this.onTap,
    this.elevation = 0,
  });

  /// Creates a tinted card — useful for service category tiles.
  const WeeshCard.tinted({
    super.key,
    required this.child,
    required Color tint,
    this.padding,
    this.borderRadius,
    this.onTap,
    this.elevation = 0,
  })  : color = tint,
        borderColor = null;

  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppRadius.cardRadius;
    
    Widget card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: effectiveRadius,
        border: Border.all(
          color: borderColor ?? AppColors.cardBorder, 
          width: 1.0,
        ),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: elevation * 4,
                  offset: Offset(0, elevation * 2),
                ),
              ]
            : null, // Default to entirely flat
      ),
      child: child,
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        borderRadius: effectiveRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveRadius,
          splashColor: AppColors.terracotta.withValues(alpha: 0.08),
          highlightColor: AppColors.terracotta.withValues(alpha: 0.04),
          child: card,
        ),
      );
    }

    return card;
  }
}
