import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:weesh_mobile/core/widgets/weesh_map.dart';
import 'package:weesh_mobile/core/ui/weesh_card.dart';
import 'package:weesh_mobile/core/ui/weesh_pulse_pin.dart';
class LocationSearchScreen extends StatelessWidget {
  const LocationSearchScreen({super.key});

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
          // Top 40% Map Layer
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: const Stack(
              alignment: Alignment.center,
              children: [
                WeeshMap(),
                // Centered Pulse Pin for pickup location
                Padding(
                  padding: EdgeInsets.only(bottom: 24), // Centered over map
                  child: WeeshPulsePin(
                    color: AppColors.terracotta,
                    icon: Icons.location_on_rounded, // Better looking solid pin
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom 60% DraggableSheet
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppPadding.section),
                  children: [
                    // Handle bar
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
                    const Gap(24),
                    _buildRouteInputs(context),
                    const Gap(24),
                    const Gap(24),
                    Text(
                      'Saved Places',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepCharcoal,
                          ),
                    ),
                    const Gap(16),
                    _buildLocationItem(
                      context,
                      icon: Iconsax.home_1,
                      title: 'Home',
                      subtitle: 'Near Municipal Hall',
                      iconColor: AppColors.primary,
                    ),
                    _buildLocationItem(
                      context,
                      icon: Iconsax.building,
                      title: 'Work',
                      subtitle: 'Downtown Business Center',
                      iconColor: AppColors.secondary,
                    ),
                    _buildLocationItem(
                      context,
                      icon: Icons.star_rounded,
                      title: 'Gym',
                      subtitle: 'Fitness First Center',
                      iconColor: AppColors.terracotta,
                    ),
                    const Gap(24),
                    Text(
                      'Recent Places',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepCharcoal,
                          ),
                    ),
                    const Gap(16),
                    _buildLocationItem(
                      context,
                      icon: Iconsax.location,
                      title: 'Plaza Rizal',
                      subtitle: '200m away',
                    ),
                    _buildLocationItem(
                      context,
                      icon: Iconsax.shop,
                      title: 'Central Market',
                      subtitle: '450m away',
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

  Widget _buildRouteInputs(BuildContext context) {
    return WeeshCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Current Location',
                        prefixIcon: Icon(Iconsax.gps, color: AppColors.primary),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const Divider(height: 24, color: AppColors.cardBorder),
                    TextField(
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Where to?',
                        prefixIcon: Icon(Icons.location_on_rounded, color: AppColors.error),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: (_) => context.push('/choose_chariot'),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.swap_vert_rounded, color: AppColors.warmGrey),
              ),
            ],
          ),
          const Gap(12),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
            label: Text(
              'Add Stop',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 36),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Color? iconColor,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: (iconColor ?? AppColors.warmGrey).withValues(alpha: 0.1),
        child: Icon(icon, color: iconColor ?? AppColors.warmGrey, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500, color: AppColors.deepCharcoal),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.plusJakartaSans(color: AppColors.warmGrey, fontSize: 13),
      ),
      onTap: () {
        context.push('/choose_chariot');
      },
    );
  }
}
