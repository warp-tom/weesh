import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:weesh_mobile/core/widgets/weesh_map.dart';
import 'package:weesh_mobile/core/ui/weesh_pulse_pin.dart';
import 'package:weesh_mobile/features/ride/data/ride_repository.dart';
import 'package:weesh_mobile/features/ride/data/isar/isar_ride.dart';
import 'package:weesh_mobile/core/database/isar/sync_status.dart';
import 'package:weesh_mobile/features/auth/application/auth_controller.dart';
import 'package:weesh_mobile/core/ui/weesh_slide_to_confirm.dart';

class ChooseChariotScreen extends ConsumerStatefulWidget {
  const ChooseChariotScreen({super.key});

  @override
  ConsumerState<ChooseChariotScreen> createState() =>
      _ChooseChariotScreenState();
}

class _ChooseChariotScreenState extends ConsumerState<ChooseChariotScreen> {
  String _selectedRideId = 'Tricycle';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: const WeeshAppBar(
        title: '',
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          // Live MapLibre map filling the background
          Positioned.fill(
            child: Stack(
              alignment: Alignment.center,
              children: [
                const WeeshMap(
                  myLocationEnabled: true,
                ),
                // Center pin offset for the bottom sheet
                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.35),
                  child: const WeeshPulsePin(
                    color: AppColors.primary,
                    icon: Icons.person_pin_circle,
                  ),
                ),
              ],
            ),
          ),

          // Bottom Sheet Overlay
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.neutral200,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.horizontal),
                      child: Text(
                        'Choose a ride',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.horizontal),
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _selectedRideId = 'Tricycle'),
                            child: _buildRideOption(
                              context,
                              title: 'Tricycle',
                              time: '3 mins',
                              price: '₱ 50.00',
                              capacity: '1-3 pax',
                              icon: Iconsax.car,
                              isSelected: _selectedRideId == 'Tricycle',
                              isRecommended: true,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _selectedRideId = 'E-Trike'),
                            child: _buildRideOption(
                              context,
                              title: 'E-Trike',
                              time: '1 min',
                              price: '₱ 60.00',
                              capacity: '1-4 pax',
                              icon: Iconsax.battery_charging,
                              isSelected: _selectedRideId == 'E-Trike',
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _selectedRideId = 'Padala'),
                            child: _buildRideOption(
                              context,
                              title: 'Padala',
                              time: '5 mins',
                              price: '₱ 45.00',
                              capacity: '1 pkg',
                              icon: Iconsax.box,
                              isSelected: _selectedRideId == 'Padala',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppPadding.section),
                      child: WeeshSlideToConfirm(
                        text: 'Slide to Book $_selectedRideId',
                        onConfirm: () async {
                          try {
                            final rideRepository = ref.read(rideRepositoryProvider);
                            final authState = ref.read(authControllerProvider);
                            final userId = authState.value?.id ?? 'guest';

                            final ride = IsarRide()
                              ..remoteId = ''
                              ..userId = userId
                              ..pickupLat = 14.5995
                              ..pickupLng = 120.9842
                              ..dropLat = 14.5547
                              ..dropLng = 121.0244
                              ..createdAt = DateTime.now()
                              ..updatedAt = DateTime.now()
                              ..syncStatus = SyncStatus.pending;

                            await rideRepository.saveRide(ride);

                            if (!context.mounted) return;
                            context.push('/booking_confirmed');
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRideOption(
    BuildContext context, {
    required String title,
    required String time,
    required String price,
    required String capacity,
    required IconData icon,
    bool isSelected = false,
    bool isRecommended = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.sageGreen.withValues(alpha: 0.05)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: isSelected ? AppColors.sageGreen : AppColors.neutral200,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.sageGreen.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.neutral500, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Iconsax.user, size: 12, color: AppColors.neutral500),
                    const SizedBox(width: 2),
                    Text(
                      capacity,
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.warmGrey),
                    ),
                  ],
                ),
                if (isRecommended) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Recommended',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  time,
                  style: GoogleFonts.plusJakartaSans(color: AppColors.warmGrey),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.deepCharcoal),
          ),
        ],
      ),
    );
  }
}
