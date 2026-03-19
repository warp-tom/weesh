import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:weesh_mobile/core/theme/constants.dart';

/// Full-page empty state with a Lottie animation, title, subtitle,
/// and an optional CTA button.
///
/// Used for: no rides, no parcels, empty wallet transaction history.
class WeeshEmptyState extends StatelessWidget {
  const WeeshEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.animationPath,
    this.action,
    this.animationSize = 220,
  });

  final String title;
  final String? subtitle;
  final String? animationPath;
  final Widget? action;
  final double animationSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.section),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (animationPath != null)
              Lottie.asset(
                animationPath!,
                width: animationSize,
                height: animationSize,
                fit: BoxFit.contain,
              )
            else
              Container(
                width: animationSize,
                height: animationSize,
                decoration: const BoxDecoration(
                  color: AppColors.heroBanner,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.inbox_outlined,
                  size: animationSize * 0.5,
                  color: AppColors.warmGrey,
                ),
              ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.deepCharcoal,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: AppColors.warmGrey,
                  height: 1.5,
                ),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 32),
              action!,
            ],
          ]
              .animate(interval: AppDurations.stagger)
              .fadeIn(duration: AppDurations.slow)
              .slideY(begin: 0.2),
        ),
      ),
    );
  }
}
