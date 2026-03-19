import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weesh_mobile/core/theme/constants.dart';

enum WeeshBadgeStatus { active, pending, delivered, cancelled, inProgress }

/// Semantic status badge pill used across ride, parcel, and wallet screens.
class WeeshBadge extends StatelessWidget {
  const WeeshBadge({
    super.key,
    required this.label,
    this.status = WeeshBadgeStatus.active,
    this.customColor,
  });

  const WeeshBadge.custom({
    super.key,
    required this.label,
    required Color color,
  })  : status = WeeshBadgeStatus.active,
        customColor = color;

  final String label;
  final WeeshBadgeStatus status;
  final Color? customColor;

  @override
  Widget build(BuildContext context) {
    final bg = customColor?.withValues(alpha: 0.12) ?? _bgColor;
    final fg = customColor ?? _fgColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }

  Color get _bgColor => switch (status) {
        WeeshBadgeStatus.active => AppColors.sageGreen,
        WeeshBadgeStatus.pending => AppColors.heroBanner,
        WeeshBadgeStatus.delivered => AppColors.sageGreen,
        WeeshBadgeStatus.cancelled => AppColors.error.withValues(alpha: 0.1),
        WeeshBadgeStatus.inProgress => AppColors.lavender,
      };

  Color get _fgColor => switch (status) {
        WeeshBadgeStatus.active => const Color(0xFF2D6A4F),
        WeeshBadgeStatus.pending => AppColors.terracotta,
        WeeshBadgeStatus.delivered => const Color(0xFF2D6A4F),
        WeeshBadgeStatus.cancelled => AppColors.error,
        WeeshBadgeStatus.inProgress => const Color(0xFF5B3FA6),
      };
}
