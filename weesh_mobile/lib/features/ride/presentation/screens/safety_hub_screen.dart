import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:weesh_mobile/core/ui/weesh_card.dart';
import 'package:gap/gap.dart';

class SafetyHubScreen extends StatelessWidget {
  const SafetyHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WeeshAppBar(title: 'Safety Hub'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.section),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.heroBanner,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.5)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Iconsax.shield_tick, color: AppColors.error, size: 48),
                  ),
                  const Gap(16),
                  Text(
                    'Your Safety is our Priority',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepCharcoal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(8),
                  Text(
                    'We actively monitor every ride to ensure you get to your destination safely. Access emergency tools below.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppColors.warmGrey,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Gap(32),
            Text(
              'Safety Tools',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.deepCharcoal,
              ),
            ),
            const Gap(16),
            WeeshCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildToolTile(
                    context,
                    title: 'Share Trip Status',
                    subtitle: 'Let loved ones track your ride live.',
                    icon: Iconsax.send_2,
                    color: AppColors.primary,
                    onTap: () {
                      // Trigger native share intent
                    },
                  ),
                  const Divider(height: 32, color: AppColors.neutral200),
                  _buildToolTile(
                    context,
                    title: 'Emergency Assistance',
                    subtitle: 'Call local authorities immediately.',
                    icon: Iconsax.call_calling,
                    color: AppColors.error,
                    onTap: () {
                      // Trigger emergency call
                    },
                  ),
                  const Divider(height: 32, color: AppColors.neutral200),
                  _buildToolTile(
                    context,
                    title: 'Record Audio',
                    subtitle: 'Securely logs audio to our servers.',
                    icon: Iconsax.microphone_2,
                    color: AppColors.terracotta,
                    onTap: () {
                      // Toggle audio recording
                    },
                  ),
                ],
              ),
            ),
            const Gap(32),
            Text(
              'Trusted Contacts',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.deepCharcoal,
              ),
            ),
            const Gap(16),
            WeeshCard(
              padding: const EdgeInsets.all(16),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: const Icon(Iconsax.add, color: AppColors.primary),
                ),
                title: Text(
                  'Add Trusted Contact',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepCharcoal,
                  ),
                ),
                subtitle: Text(
                  'They will be notified of your trips.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.warmGrey,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.neutral500),
                onTap: () => context.push('/emergency_contacts'),
              ),
            ),
            const Gap(32),
          ],
        ),
      ),
    );
  }

  Widget _buildToolTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepCharcoal,
                  ),
                ),
                const Gap(4),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.neutral500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.neutral500),
        ],
      ),
    );
  }
}
