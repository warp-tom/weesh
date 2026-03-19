import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/core/ui/weesh_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.section),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Illustration
              Expanded(
                child: Center(
                  child: ClipRRect(
                    borderRadius: AppRadius.cardRadius,
                    child: Image.asset(
                      'assets/images/welcome_illustration.png',
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: AppDurations.slow)
                    .scale(begin: const Offset(0.95, 0.95)),
              ),
              const Gap(32),

              // Tagline with typewriter animation
              Text(
                'Komusta! Welcome to',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.warmGrey,
                ),
              ).animate(delay: 300.ms).fadeIn(duration: AppDurations.normal),
              const Gap(4),
              Row(
                children: [
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'the Province.',
                        textStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.terracotta,
                        ),
                        speed: const Duration(milliseconds: 70),
                      ),
                    ],
                    totalRepeatCount: 1,
                    pause: const Duration(milliseconds: 500),
                  ),
                ],
              ).animate(delay: 400.ms).fadeIn(duration: AppDurations.normal),
              const Gap(8),
              Text(
                'Ride. Deliver. Shop — all in one.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  color: AppColors.warmGrey,
                  height: 1.5,
                ),
              )
                  .animate(delay: 550.ms)
                  .fadeIn(duration: AppDurations.normal)
                  .slideY(begin: 0.1),

              const Gap(AppPadding.section),

              // CTA Buttons
              WeeshButton.filled(
                label: 'I need a Ride',
                onTap: () => context.push('/login'),
              ).animate(delay: 700.ms).fadeIn(duration: AppDurations.normal).slideY(begin: 0.2),
              const Gap(AppPadding.item),
              WeeshButton.ghost(
                label: 'I want to drive',
                onTap: () => context.push('/login'),
              ).animate(delay: 800.ms).fadeIn(duration: AppDurations.normal).slideY(begin: 0.2),
              const Gap(16),
            ],
          ),
        ),
      ),
    );
  }
}
