import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/core/widgets/weesh_map.dart';
import 'package:weesh_mobile/features/ride/application/active_ride_provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:gap/gap.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ActiveRideScreen extends ConsumerWidget {
  const ActiveRideScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rideAsync = ref.watch(activeRideStreamProvider);
    final driverAsync = ref.watch(assignedDriverProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Full-screen map
          const Positioned.fill(
            child: WeeshMap(myLocationEnabled: true),
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

          // Bottom sheet
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
                  BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, -5)),
                ],
              ),
              child: SafeArea(
                top: false,
                child: rideAsync.when(
                  loading: () => _buildFindingState(context),
                  error: (error, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Iconsax.warning_2, color: AppColors.error, size: 48),
                          const Gap(16),
                          Text('Connection lost', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16)),
                          const Gap(8),
                          Text(error.toString(), textAlign: TextAlign.center, style: GoogleFonts.plusJakartaSans(color: AppColors.textLight, fontSize: 12)),
                          const Gap(24),
                          OutlinedButton(
                            onPressed: () => ref.refresh(activeRideStreamProvider),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  data: (ride) {
                    if (ride == null || ride.status == WeeshRideStatus.pending) {
                      return _buildFindingState(context);
                    }
                    return _buildDriverEnRouteState(context, ride, driverAsync);
                  },
                ),
              ),
            ),
          ),

          // Pickup label ribbon (always visible while active)
          rideAsync.when(
            data: (ride) {
              if (ride?.pickupLabel == null) return const SizedBox.shrink();
              return Positioned(
                top: MediaQuery.of(context).padding.top + 70,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: AppShadows.soft,
                  ),
                  child: Row(
                    children: [
                      const Icon(Iconsax.location_tick, color: AppColors.primary),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pickup', style: GoogleFonts.plusJakartaSans(
                              fontSize: 11, color: AppColors.warmGrey)),
                            Text(ride!.pickupLabel!, style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.bold, color: AppColors.deepCharcoal)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildFindingState(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            width: 4, height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: AppColors.neutral200, borderRadius: BorderRadius.circular(2)),
          ),
        ),
        const Gap(16),
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Center(child: SizedBox(
            width: 40, height: 40,
            child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3),
          )),
        ),
        const Gap(24),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 60),
          child: DefaultTextStyle(
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20, color: AppColors.primary,
              fontWeight: FontWeight.bold, height: 1.3,
            ),
            textAlign: TextAlign.center,
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText('Connecting you to nearby drivers...',
                  speed: const Duration(milliseconds: 50), textAlign: TextAlign.center),
                TypewriterAnimatedText('Negotiating best fares...',
                  speed: const Duration(milliseconds: 50), textAlign: TextAlign.center),
              ],
              repeatForever: true,
            ),
          ),
        ),
        const Gap(32),
        // Skeleton driver card
        Row(children: [
          Container(width: 56, height: 56,
            decoration: const BoxDecoration(color: AppColors.surfaceDim, shape: BoxShape.circle)),
          const Gap(16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(height: 14, width: 140, color: AppColors.surfaceDim),
            const Gap(8),
            Container(height: 10, width: 80, color: AppColors.surfaceDim),
          ])),
          Container(height: 30, width: 60, color: AppColors.surfaceDim),
        ]),
        const Gap(24),
      ],
    );
  }

  Widget _buildDriverEnRouteState(BuildContext context, WeeshRide ride, AsyncValue driverAsync) {
    final driver = driverAsync.value;
    final driverName = driver?.name ?? 'Your Driver';
    final rating = driver?.rating.toStringAsFixed(1) ?? '4.9';
    final plate = driver?.plateNumber ?? '--- ----';
    final photoUrl = driver?.photoUrl;
    final otp = ride.requestCode.isNotEmpty ? ride.requestCode : '----';
    final fare = ride.fare != null ? '₱${ride.fare!.toStringAsFixed(2)}' : 'Computing...';

    final String statusLabel = () {
      switch (ride.status) {
        case WeeshRideStatus.inProgress: return 'IN PROGRESS';
        case WeeshRideStatus.completed: return 'COMPLETED';
        case WeeshRideStatus.cancelled: return 'CANCELLED';
        case WeeshRideStatus.accepted: return 'ACCEPTED';
        default: return ride.status.name.toUpperCase();
      }
    }();

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(child: Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: AppColors.neutral200, borderRadius: BorderRadius.circular(2)),
          )),

          // Status chip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Driver is on the way', style: GoogleFonts.plusJakartaSans(
                fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.deepCharcoal)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(statusLabel,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ),
          const Gap(4),
          Text('Fare: $fare', style: GoogleFonts.plusJakartaSans(
            fontSize: 14, color: AppColors.warmGrey)),
          const Gap(20),

          // Route
          if (ride.pickupLabel != null || ride.dropoffLabel != null)
            Row(children: [
              Column(children: [
                const Icon(Icons.circle, size: 12, color: AppColors.primary),
                Container(width: 2, height: 24, color: AppColors.neutral200),
                const Icon(Icons.location_on, size: 16, color: AppColors.error),
              ]),
              const Gap(16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (ride.pickupLabel != null)
                  Text(ride.pickupLabel!, style: GoogleFonts.plusJakartaSans(
                    fontSize: 14, color: AppColors.deepCharcoal, fontWeight: FontWeight.w600)),
                const Gap(18),
                if (ride.dropoffLabel != null)
                  Text(ride.dropoffLabel!, style: GoogleFonts.plusJakartaSans(
                    fontSize: 14, color: AppColors.deepCharcoal, fontWeight: FontWeight.w600)),
              ])),
            ]),
          const Gap(20),
          const Divider(color: AppColors.neutral200),
          const Gap(16),

          // Driver info card
          Row(children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: photoUrl != null ? NetworkImage(photoUrl) as ImageProvider : null,
              backgroundColor: AppColors.surfaceDim,
              child: photoUrl == null ? const Icon(Iconsax.user, color: AppColors.warmGrey) : null,
            ),
            const Gap(16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(driverName, style: GoogleFonts.plusJakartaSans(
                  fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.deepCharcoal)),
                const Gap(6),
                const Icon(Icons.verified, color: Colors.blue, size: 16),
              ]),
              const Gap(4),
              Row(children: [
                const Icon(Iconsax.star_1, size: 14, color: AppColors.secondary),
                const Gap(4),
                Text(rating, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold)),
              ]),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(driver?.vehicleType ?? 'Motorcycle',
                style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.warmGrey)),
              const Gap(4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.amber.shade400),
                ),
                child: Text(plate, style: GoogleFonts.getFont(
                  'Roboto Mono', fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
              ),
            ]),
          ]),
          const Gap(20),

          // OTP / Request code display
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceDim,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(children: [
              Text('Show this code to your driver', style: GoogleFonts.plusJakartaSans(
                color: AppColors.warmGrey, fontSize: 13)),
              const Gap(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: otp.split('').take(6).map((digit) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 42, height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  alignment: Alignment.center,
                  child: Text(digit, style: GoogleFonts.plusJakartaSans(
                    fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
                )).toList(),
              ),
            ]),
          ),
          const Gap(20),

          // Action buttons
          Row(children: [
            Expanded(child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                foregroundColor: AppColors.deepCharcoal,
                side: const BorderSide(color: AppColors.neutral200),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Call coming soon')));
              },
              icon: const Icon(Iconsax.call), label: const Text('Call'),
            )),
            const Gap(12),
            Expanded(child: FilledButton.icon(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                HapticFeedback.selectionClick();
                context.push('/chat');
              },
              icon: const Icon(Iconsax.message), label: const Text('Chat'),
            )),
            const Gap(12),
            Container(
              height: 48, width: 48,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                color: AppColors.error,
                icon: const Icon(Icons.shield_outlined),
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Emergency SOS'),
                      content: const Text('Call local emergency services: 911'),
                      actions: [TextButton(
                        onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
                    ),
                  );
                },
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
