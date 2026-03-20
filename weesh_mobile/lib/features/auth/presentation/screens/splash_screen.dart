import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:weesh_mobile/core/theme/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // GoRouter redirect will catch this and send to /welcome or /home based on auth
        context.go('/welcome');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Minimalist Logo Presentation
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.cardBorder, width: 1),
              ),
              child: const Center(
                child: Icon(
                  Icons.electric_rickshaw,
                  size: 60,
                  color: AppColors.primary, // Matcha
                ),
              ),
            ),
            const Gap(24), // Increased spacing for Ma
            Text(
              'Your Wish, Our Wheels',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textBody, // Sumi Ink instead of primary
                  ),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: 1200.ms, curve: Curves.easeOutCubic)
            .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.0, 1.0),
              duration: 1200.ms,
              curve: Curves.easeOutCubic,
            ),
      ),
    );
  }
}
