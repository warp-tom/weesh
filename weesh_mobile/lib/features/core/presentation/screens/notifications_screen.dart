import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:gap/gap.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WeeshAppBar(
        title: 'Notifications',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: null, // Would mark all as read
              child: Text('Mark all read', style: TextStyle(color: AppColors.primary)),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppPadding.section),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.section),
            child: Text('Today', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.neutral500)),
          ),
          const Gap(12),
          const _NotificationTile(
            icon: Iconsax.box,
            title: 'Your parcel has been delivered!',
            subtitle: 'Order #PRC-391 has arrived at the destination. Thank you for using Weesh Parcel.',
            time: '10:45 AM',
            isUnread: true,
          ),
          const _NotificationTile(
            icon: Iconsax.wallet_3,
            title: 'GCash Cash-in Successful',
            subtitle: '₱ 500.00 has been added to your WeeshPay balance.',
            time: '09:00 AM',
            isUnread: true,
            iconBackgroundColor: AppColors.success,
          ),
          const Gap(24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.section),
            child: Text('Earlier', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.neutral500)),
          ),
          const Gap(12),
          const _NotificationTile(
            icon: Iconsax.discount_shape,
            title: '₱ 50 Off Your Next Ride',
            subtitle: 'Use code WEESHWEEKEND. Valid until Sunday only!',
            time: 'Yesterday',
            isUnread: false,
            iconBackgroundColor: AppColors.primary,
          ),
          const _NotificationTile(
            icon: Iconsax.location,
            title: 'Driver has arrived',
            subtitle: 'Kuya Juan is waiting outside your pickup location.',
            time: 'Oct 23',
            isUnread: false,
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isUnread = false,
    this.iconBackgroundColor = AppColors.deepCharcoal,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final bool isUnread;
  final Color iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isUnread ? AppColors.primary.withValues(alpha: 0.05) : AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.section, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUnread ? iconBackgroundColor : AppColors.neutral200,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isUnread ? Colors.white : AppColors.neutral500, size: 20),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(title, style: TextStyle(fontWeight: isUnread ? FontWeight.bold : FontWeight.w600))),
                    const Gap(8),
                    Text(time, style: TextStyle(color: isUnread ? AppColors.primary : AppColors.neutral500, fontSize: 12, fontWeight: isUnread ? FontWeight.bold : FontWeight.normal)),
                  ],
                ),
                const Gap(4),
                Text(subtitle, style: TextStyle(color: isUnread ? AppColors.deepCharcoal : AppColors.neutral500, fontSize: 13, height: 1.4)),
              ],
            ),
          ),
          if (isUnread) ...[
            const Gap(12),
            Container(
              margin: const EdgeInsets.only(top: 6),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            )
          ]
        ],
      ),
    );
  }
}
