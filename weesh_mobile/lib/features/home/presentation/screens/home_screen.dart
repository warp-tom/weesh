import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:simple_animations/simple_animations.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  double _sheetProgress = 0.0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _runBackgroundSync());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationPermission();
    });
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      if (mounted) context.push('/priming');
    }
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
            'Rider';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Full Screen Breathing Map
          const Positioned.fill(
            child: WeeshMap(
              myLocationEnabled: false, // Disable native, use custom
              compassEnabled: false,
            ),
          ),

          // Custom Breathing Pin in the center
          Positioned.fill(
            child: Center(
              child: _buildBreathingPin(),
            ),
          ),

          // 2. Map Dimming Overlay linked to Sheet Drag
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                color: Colors.black.withValues(alpha: _sheetProgress * 0.6),
              ),
            ),
          ),

          // 3. Floating Header & Dynamic Island Activity Pill
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.section),
                child: Column(
                  children: [
                    const Gap(16),
                    // Header — instant
                    _buildHeader(context, userName)
                        .animate()
                        .fadeIn(duration: AppDurations.normal),

                    // Mock Live Activity Pill
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        context.push('/driver_en_route');
                      },
                      child: _buildLiveActivityPill()
                          .animate()
                          .fadeIn(duration: AppDurations.normal)
                          .slideY(begin: -0.1),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Fluid Draggable Bottom Sheet
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              setState(() {
                final extent = notification.extent;
                final minExtent = notification.minExtent;
                final maxExtent = notification.maxExtent;
                _sheetProgress = ((extent - minExtent) / (maxExtent - minExtent)).clamp(0.0, 1.0);
              });
              return true;
            },
            child: DraggableScrollableSheet(
              initialChildSize: 0.45,
              minChildSize: 0.45,
              maxChildSize: 0.9,
              snap: true,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    border: Border(top: BorderSide(color: AppColors.cardBorder)),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: AppPadding.section),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(12),
                        // Drag Handle
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.neutral500,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const Gap(24),
                        // Universal Search
                        _buildUniversalSearch(context)
                            .animate(delay: 100.ms)
                            .fadeIn(duration: AppDurations.normal)
                            .slideY(begin: 0.1),
                        const Gap(28),
                        // Hero Banner
                        _buildHeroBanner(context)
                            .animate(delay: 200.ms)
                            .fadeIn(duration: AppDurations.slow)
                            .slideY(begin: 0.12, curve: Curves.easeOut),
                        const Gap(28),
                        // Section header
                        Text(
                          'Explore Weesh',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepCharcoal,
                          ),
                        ).animate(delay: 300.ms).fadeIn(duration: AppDurations.normal),
                        const Gap(16),
                        // Service tiles
                        _buildServiceCategories(context)
                            .animate(delay: 400.ms)
                            .fadeIn(duration: AppDurations.slow)
                            .slideX(begin: 0.1, curve: Curves.easeOut),
                        const Gap(40),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
        border: Border.all(color: AppColors.cardBorder),
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
                  color: AppColors.primary, // Matcha pulse
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
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
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardBorder),
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

  Widget _buildUniversalSearch(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        context.push('/location_search');
      },
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
                'Where to or What to buy?',
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

  Widget _buildBreathingPin() {
    return MirrorAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOutSine,
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 60 + (value * 40),
              height: 60 + (value * 40),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1 + (0.2 * (1 - value))),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

