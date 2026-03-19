import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/core/widgets/weesh_map.dart';
import 'package:gap/gap.dart';

class ParcelServiceTypeScreen extends StatelessWidget {
  const ParcelServiceTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Map Background placeholder
          const Positioned.fill(
            child: WeeshMap(
              myLocationEnabled: false,
            ),
          ),
          
          // Back button
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

          // Bottom Sheet with Routing & Fee Details
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(AppPadding.section),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Select Vehicle', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const Gap(12),
                    SizedBox(
                      height: 84,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: const [
                          _VehicleCard(icon: Icons.two_wheeler, name: 'Motor', time: '5 mins', isSelected: true),
                          Gap(12),
                          _VehicleCard(icon: Icons.electric_rickshaw, name: 'Tricycle', time: '12 mins'),
                          Gap(12),
                          _VehicleCard(icon: Icons.local_shipping, name: 'L300 Van', time: '30 mins'),
                        ],
                      ),
                    ),
                    const Gap(24),
                    Text('Routing & Fee', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const Gap(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             const Text('Distance', style: TextStyle(color: AppColors.neutral500)),
                             Text('4.2 km', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                           ]
                         ),
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.end,
                           children: [
                             const Text('Estimated Time', style: TextStyle(color: AppColors.neutral500)),
                             Text('24 mins', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                           ]
                         )
                      ],
                    ),
                    const Divider(height: 32, color: AppColors.neutral200),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Delivery Fee', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('₱ 85.00', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ]
                    ),
                    const Gap(24),
                    FilledButton(
                      onPressed: () {
                        context.push('/parcel_tracking');
                      },
                      child: const Text('Confirm Delivery'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({
    required this.icon,
    required this.name,
    required this.time,
    this.isSelected = false,
  });

  final IconData icon;
  final String name;
  final String time;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.deepCharcoal : AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: isSelected ? null : Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: isSelected ? Colors.white : AppColors.deepCharcoal),
          const Spacer(),
          Text(name, style: TextStyle(color: isSelected ? Colors.white : AppColors.deepCharcoal, fontWeight: FontWeight.bold, fontSize: 13)),
          Text(time, style: TextStyle(color: isSelected ? AppColors.neutral200 : AppColors.neutral500, fontSize: 11)),
        ],
      ),
    );
  }
}
