import 'package:flutter/material.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:weesh_mobile/core/ui/weesh_card.dart';

class PromoVouchersScreen extends StatelessWidget {
  const PromoVouchersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WeeshAppBar(
        title: 'Promo & Vouchers',
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppPadding.section),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter promo code',
                        prefixIcon:
                            Icon(Iconsax.ticket_2, color: AppColors.neutral500),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () {
                      // Apply promo code action
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                    ),
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.section),
              child: Divider(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppPadding.section),
                children: [
                  Text(
                    'Available Vouchers',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildVoucherCard(
                    context,
                    title: '20% Off Ride',
                    subtitle: 'Max discount ₱50.00',
                    expiry: 'Valid until Dec 31',
                    color: AppColors.secondary,
                  ),
                  _buildVoucherCard(
                    context,
                    title: '₱30 Off Pabili',
                    subtitle: 'Minimum spend ₱300.00',
                    expiry: 'Valid until Nov 30',
                    color: AppColors.tertiary,
                  ),
                  _buildVoucherCard(
                    context,
                    title: 'Free Delivery',
                    subtitle: 'For Instant Courier service only',
                    expiry: 'Valid until Oct 15',
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoucherCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String expiry,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: WeeshCard(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        borderColor: color.withValues(alpha: 0.3),
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Iconsax.discount_shape, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color != AppColors.secondary
                              ? color
                              : Colors
                                  .orange[900], // Ensure legibility on yellow
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.neutral500,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    expiry,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: () {
                // Use voucher action
              },
              style: FilledButton.styleFrom(
                backgroundColor: color,
                foregroundColor: color == AppColors.secondary
                    ? Colors.black87
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Use Now'),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
