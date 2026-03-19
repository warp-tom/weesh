import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/core/widgets/weesh_map.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:gap/gap.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:weesh_mobile/core/ui/weesh_skeleton.dart';

class ActiveRideScreen extends StatefulWidget {
  const ActiveRideScreen({super.key});

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen> {
  bool _isFinding = true;
  Timer? _findDriverTimer;

  @override
  void initState() {
    super.initState();
    // Simulate finding driver network delay for demonstration
    if (kDebugMode) {
      _findDriverTimer = Timer(const Duration(seconds: 4), () {
        if (mounted) setState(() => _isFinding = false);
      });
    }
  }

  @override
  void dispose() {
    _findDriverTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Full-screen MapLibre map
          const Positioned.fill(
            child: WeeshMap(
              myLocationEnabled: true,
            ),
          ),

          // Scaffold app bar equivalent on top of Map
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: CircleAvatar(
              backgroundColor: AppColors.surface,
              child: BackButton(
                color: AppColors.textBody,
                onPressed: () => context.pop(),
              ),
            ),
          ),

          // Bottom Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(AppPadding.section),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                      if (_isFinding)
                        _buildFindingDriverState(context)
                      else
                        _buildDriverEnRouteState(context),
                    ],
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildFindingDriverState(BuildContext context) {
    return Column(
      children: [
        const Gap(16),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 60),
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
            textAlign: TextAlign.center,
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Connecting you to nearby drivers...',
                  speed: const Duration(milliseconds: 50),
                  textAlign: TextAlign.center,
                ),
                TypewriterAnimatedText(
                  'Negotiating best fares...',
                  speed: const Duration(milliseconds: 50),
                  textAlign: TextAlign.center,
                ),
              ],
              repeatForever: true,
            ),
          ),
        ),
        const Gap(16),
        // Skeleton Handoff precisely matching Driver Info Card geometry
        WeeshSkeleton.driverCard(),
        const Gap(32),
      ],
    );
  }

  Widget _buildDriverEnRouteState(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Driver En Route',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const Gap(16),
        // Driver Info Card
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (kDebugMode) {
                    context.push('/ride_completion'); // Demo navigation
                  }
                },
                child: const CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=11'),
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kuya Cardo',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Text(
                      'Honda Click • ABC 1234',
                      style: TextStyle(
                          color: AppColors.warmGrey,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      AppColors.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Iconsax.star_1,
                        size: 14, color: AppColors.secondary),
                    Gap(4),
                    Text('4.9',
                        style:
                            TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
        ),
        const Gap(16),
        // OTP Display
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.sageGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.sageGreen),
          ),
          child: Column(
            children: [
              const Text('Give this PIN to your driver',
                  style: TextStyle(color: AppColors.warmGrey)),
              const Gap(4),
              // TODO: Replace with dynamically generated OTP from ride state
              Text(
                '7 4 9 2',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 16,
                      color: AppColors.primary,
                    ),
              ),
            ],
          ),
        ),
        const Gap(24),
        // Actions
        Row(
          children: [
            IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.neutral200),
                )
              ),
              onPressed: () {
                // TODO: Implement call driver functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Call functionality coming soon.')),
                );
              },
              icon: const Icon(Iconsax.call),
            ),
            const Gap(8),
            IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.neutral200),
                )
              ),
              onPressed: () => context.push('/chat'), // Changed to generic chat destination
              icon: const Icon(Iconsax.message),
            ),
            const Gap(8),
            Expanded(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // TODO: Implement emergency SOS functionality
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Emergency SOS'),
                      content: const Text('SOS functionality coming soon. In an emergency, please call local emergency services.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.warning_amber_rounded),
                label: const Text('SOS'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
