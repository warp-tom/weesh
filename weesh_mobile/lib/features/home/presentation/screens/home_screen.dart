import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:gap/gap.dart';
import 'package:weesh_mobile/features/auth/application/auth_controller.dart';
import 'package:weesh_mobile/features/ride/application/ride_sync_service.dart';
import 'package:weesh_mobile/features/parcel/application/parcel_sync_service.dart';
import 'package:weesh_mobile/features/pabili/application/grocery_sync_service.dart';
import 'package:weesh_mobile/core/widgets/weesh_map.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _runBackgroundSync());
  }

  Future<void> _runBackgroundSync() async {
    try {
      await ref.read(rideSyncServiceProvider).syncPendingRides();
      await ref.read(parcelSyncServiceProvider).syncPendingParcels();
      await ref.read(grocerySyncServiceProvider).syncPendingOrders();
    } catch (e) {
      // Silently catch background errors
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final userName =
        authState.value?.userMetadata?['full_name'] as String? ??
            'Juan Dela Cruz';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.section),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(16),
              // Header — instant
              _buildHeader(context, userName)
                  .animate()
                  .fadeIn(duration: AppDurations.normal),

              // Mock Live Activity Pill (In production, wrap with a provider check)
              GestureDetector(
                onTap: () => context.push('/driver_en_route'),
                child: _buildLiveActivityPill()
                    .animate()
                    .fadeIn(duration: AppDurations.normal)
                    .slideY(begin: -0.1),
              ),
              
              const Gap(24),
              // Hero Banner — slides up first
              _buildHeroBanner(context)
                  .animate()
                  .fadeIn(duration: AppDurations.slow)
                  .slideY(begin: 0.12, curve: Curves.easeOut),
              const Gap(28),
              // Section header
              Text(
                'Explore by popular way',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepCharcoal,
                ),
              ).animate(delay: 150.ms).fadeIn(duration: AppDurations.normal),
              const Gap(16),
              // Service tiles — staggered
              _buildServiceCategories(context)
                  .animate(delay: 200.ms)
                  .fadeIn(duration: AppDurations.slow)
                  .slideX(begin: 0.1, curve: Curves.easeOut),
              const Gap(28),
              // Search bar
              _buildSearchBar(context)
                  .animate(delay: 300.ms)
                  .fadeIn(duration: AppDurations.normal)
                  .slideY(begin: 0.1),
              const Gap(28),
              // Map section header
              Text(
                'Take a look around you',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepCharcoal,
                ),
              ).animate(delay: 380.ms).fadeIn(duration: AppDurations.normal),
              const Gap(16),
              _buildMapSection()
                  .animate(delay: 420.ms)
                  .fadeIn(duration: AppDurations.slow)
                  .slideY(begin: 0.1),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  Widget _buildLiveActivityPill() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(100),
        boxShadow: AppShadows.soft,
        border: Border.all(color: AppColors.terracotta.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.terracotta,
                  shape: BoxShape.circle,
                ),
              ).animate(onPlay: (controller) => controller.repeat(reverse: true))
               .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 800.ms),
              const Gap(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Driver arriving in 3 mins',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepCharcoal,
                    ),
                  ),
                  Text(
                    'Honda Click • ABC 1234',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.neutral500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.terracotta),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String userName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreeting(),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppColors.warmGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(4),
            Text(
              userName.split(' ').first,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.w800, // ExtraBold for high contrast hierarchy
                color: AppColors.deepCharcoal,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: IconButton(
            onPressed: () => context.push('/notifications'),
            icon: const Icon(Iconsax.notification, color: AppColors.deepCharcoal),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Are you ready for a',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: AppColors.deepCharcoal,
                  ),
                ),
                Text(
                  'smooth ride?',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepCharcoal,
                  ),
                ),
                const Gap(4),
                Text(
                  'Sit back, relax and enjoy the ride.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.warmGrey,
                  ),
                ),
                const Gap(16),
                SizedBox(
                  height: 40,
                  child: FilledButton(
                    onPressed: () => context.push('/location_search'),
                    style: FilledButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Ride with Weesh',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(12),
          Expanded(
            flex: 2,
            child: Image.asset(
              'assets/images/ride_illustration.png',
              height: 120,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.neutral100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Iconsax.driving,
                    size: 48,
                    color: AppColors.terracotta,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCategories(BuildContext context) {
    return Row(
      children: [
        _buildCategoryTile(
          context,
          title: 'Ride',
          color: AppColors.sageGreen,
          icon: Iconsax.car,
          imagePath: 'assets/images/ride_illustration.png',
          onTap: () => context.push('/location_search'),
        ),
        const Gap(12),
        _buildCategoryTile(
          context,
          title: 'Parcel',
          color: AppColors.heroBanner,
          icon: Iconsax.box,
          imagePath: 'assets/images/parcel_illustration.png',
          onTap: () => context.push('/parcel_receiver_details'),
        ),
        const Gap(12),
        _buildCategoryTile(
          context,
          title: 'Pabili',
          color: AppColors.lavender,
          icon: Iconsax.shopping_cart,
          imagePath: 'assets/images/pabili_illustration.png',
          onTap: () => context.push('/pabili_store_selection'),
        ),
      ],
    );
  }

  Widget _buildCategoryTile(
    BuildContext context, {
    required String title,
    required Color color,
    required IconData icon,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppShadows.soft,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepCharcoal,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    size: 14,
                    color: AppColors.warmGrey,
                  ),
                ],
              ),
              const Gap(8),
              SizedBox(
                height: 60,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(icon, size: 40, color: AppColors.terracotta);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/location_search'),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.warmGrey, size: 22),
            const Gap(12),
            Expanded(
              child: Text(
                'Where to?',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  color: AppColors.warmGrey,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time, size: 14, color: AppColors.deepCharcoal),
                  const Gap(4),
                  Text(
                    'Now',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.deepCharcoal,
                    ),
                  ),
                  const Gap(2),
                  const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.deepCharcoal),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.soft,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            const WeeshMap(
              myLocationEnabled: false, 
              compassEnabled: false,
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.8),
                    Colors.white,
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: FilledButton.icon(
                  onPressed: () => context.push('/location_search'),
                  icon: const Icon(Iconsax.map_1, size: 18),
                  label: Text(
                    'Set Pickup Location',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
