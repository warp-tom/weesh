import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:gap/gap.dart';

class PermissionPrimingScreen extends StatelessWidget {
  final VoidCallback onAllow;
  final VoidCallback onSkip;

  const PermissionPrimingScreen({
    super.key,
    required this.onAllow,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(48),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.location,
                  color: Colors.white,
                  size: 64,
                ),
              ),
              const Gap(32),
              Text(
                'Let\'s find your chariot.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const Gap(16),
              Text(
                'Weesh uses your location to show nearby drivers, estimate pickup times, and ensure your safety during rides.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.8),
                  height: 1.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppShadows.soft,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(Iconsax.shield_tick, color: AppColors.terracotta, size: 24),
                        const Gap(12),
                        Expanded(
                          child: Text(
                            'Your precise location is never shared with drivers until you book a ride.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: AppColors.warmGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(24),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: onAllow,
                      child: Text(
                        'Allow Location Access',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Gap(12),
                    TextButton(
                      onPressed: () {
                        context.pop(); // or onSkip
                      },
                      child: Text(
                        'Not right now',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.neutral500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
