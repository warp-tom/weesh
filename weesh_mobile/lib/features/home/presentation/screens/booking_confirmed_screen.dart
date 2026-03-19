import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BookingConfirmedScreen extends StatelessWidget {
  const BookingConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.section),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Lottie.asset(
                  'assets/animations/searching_banana.json',
                  width: 200,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Iconsax.search_status,
                            size: 80, color: AppColors.primary),
                      ),
                    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                     .scaleXY(begin: 0.9, end: 1.1, duration: 1.seconds, curve: Curves.easeInOut)
                     .fade(begin: 0.5, end: 1.0, duration: 1.seconds);
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Finding your chariot...',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '0:45',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.primary,
                    ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('Cancel Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
