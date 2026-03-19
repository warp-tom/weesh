import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/core/widgets/weesh_map.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:gap/gap.dart';

class ParcelTrackingScreen extends StatelessWidget {
  const ParcelTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Full-screen MapLibre map taking up top portion before sheet covers
          const Positioned.fill(
            child: WeeshMap(
              myLocationEnabled: false,
            ),
          ),
          
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

          // Tracking Details Section (Bottom Draggable or Align)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.60,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
              ),
              child: ListView(
                padding: const EdgeInsets.all(AppPadding.section),
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Iconsax.box, color: AppColors.primary),
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Courier is on the way',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const Gap(4),
                            Text(
                              'Estimated arrival: 2:45 PM',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(32),
                  // Stepper Visual
                  _buildStep(context,
                      title: 'Driver Assigned',
                      time: '2:00 PM',
                      isCompleted: true,
                      isLast: false),
                  _buildStep(context,
                      title: 'Picked Up',
                      time: '2:15 PM',
                      isCompleted: true,
                      isLast: false),
                  _buildStep(context,
                      title: 'In Transit',
                      time: '2:30 PM',
                      isCompleted: true,
                      isActive: true,
                      isLast: false),
                  _buildStep(context,
                      title: 'Delivered',
                      time: 'Pending',
                      isCompleted: false,
                      isLast: true),
                      
                  const Gap(24),
                  OutlinedButton(
                    onPressed: () {
                      context.go('/home');
                    },
                    child: const Text('Back to Home'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
    BuildContext context, {
    required String title,
    required String time,
    required bool isCompleted,
    bool isActive = false,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? AppColors.primary
                    : isCompleted
                        ? AppColors.primary
                        : AppColors.neutral200,
                border: isActive
                    ? Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 4)
                    : null,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? AppColors.primary : AppColors.neutral200,
              ),
          ],
        ),
        const Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                  fontSize: 16,
                  color: isCompleted || isActive
                      ? AppColors.textBody
                      : AppColors.neutral500,
                ),
              ),
              const Gap(4),
              Text(
                time,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.neutral500,
                    ),
              ),
              if (!isLast) const Gap(24),
            ],
          ),
        ),
      ],
    );
  }
}
