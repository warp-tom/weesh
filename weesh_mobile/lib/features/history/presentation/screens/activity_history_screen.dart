import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/core/ui/weesh_card.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:gap/gap.dart';
import 'package:weesh_mobile/core/widgets/error_state_widget.dart';
import 'package:weesh_mobile/features/history/application/history_provider.dart';
import 'package:weesh_mobile/features/history/domain/models/activity.dart';
import 'package:weesh_mobile/core/ui/weesh_skeleton.dart';

class ActivityHistoryScreen extends ConsumerWidget {
  const ActivityHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeItemsState = ref.watch(activeActivitiesProvider);
    final pastItemsState = ref.watch(pastActivitiesProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        // ignore: weesh_no_generic_appbar
        appBar: AppBar(
          title: Text(
            'Activity',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.deepCharcoal,
            ),
          ),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textLight,
            indicatorColor: AppColors.primary,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
            ),
            tabs: const [
              Tab(text: 'Active'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(context, ref, activeItemsState, isActive: true),
            _buildList(context, ref, pastItemsState, isActive: false),
          ],
        ),

      ),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref, AsyncValue<List<Activity>> state, {required bool isActive}) {
    return state.when(
      loading: () => ListView.separated(
        padding: const EdgeInsets.all(AppPadding.section),
        itemCount: 4,
        separatorBuilder: (_, __) => const Gap(12),
        itemBuilder: (_, __) => WeeshSkeleton.card(),
      ),
      error: (err, stack) => ErrorStateWidget(
        message: 'We couldn\'t load your activities. $err',
        onRetry: () => ref.refresh(isActive ? activeActivitiesProvider : pastActivitiesProvider),
      ),
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/illustrations/ride_finding.png',
                  width: 160,
                  height: 160,
                ),
                const Gap(16),
                Text(
                  isActive ? 'No active orders yet' : 'No past activities',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.deepCharcoal,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(6),
                Text(
                  isActive
                      ? 'Start a ride, Pabili, or send a parcel!'
                      : 'Your completed trips will appear here.',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textLight,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(AppPadding.section),
          itemCount: items.length,
          separatorBuilder: (context, index) => const Gap(12),
          itemBuilder: (context, index) {
            final item = items[index];

            IconData icon;
            Color iconColor;
            final typeLower = item.type.toLowerCase();
            final statusLower = item.status.toLowerCase();

            switch (typeLower) {
              case 'ride':
                icon = Iconsax.car;
                iconColor = AppColors.primary;
                break;
              case 'pabili':
                icon = Iconsax.shopping_cart;
                iconColor = AppColors.secondary;
                break;
              case 'parcel':
                icon = Iconsax.box;
                iconColor = AppColors.primary;
                break;
              case 'top_up':
                icon = Iconsax.wallet_add;
                iconColor = const Color(0xFF007DFE);
                break;
              default:
                icon = Iconsax.receipt_2;
                iconColor = AppColors.warmGrey;
            }

            // Adjust colors based on status
            if (statusLower == 'cancelled') {
              iconColor = AppColors.error;
            }

            final dateStr = '${item.createdAt.month}/${item.createdAt.day}/${item.createdAt.year}';
            final amountPrefix = (item.type == 'top_up') ? '+' : '';

            return _buildHistoryCard(
              context,
              title: item.title,
              date: dateStr,
              amount: '$amountPrefix₱${item.amount.toStringAsFixed(2)}',
              status: item.status,
              icon: icon,
              iconColor: iconColor,
            );
          },
        );
      },
    );
  }

  Widget _buildHistoryCard(
    BuildContext context, {
    required String title,
    required String date,
    required String amount,
    required String status,
    required IconData icon,
    required Color iconColor,
  }) {
    final statusLower = status.toLowerCase();
    final bool isCancelled = statusLower == 'cancelled';
    final bool isCompleted = statusLower == 'completed';
    final bool isPending = statusLower == 'pending' || statusLower == 'in transit';

    Color statusColor;
    if (isCancelled) {
      statusColor = AppColors.error;
    } else if (isPending) {
      statusColor = AppColors.secondary;
    } else {
      statusColor = AppColors.primary;
    }

    return WeeshCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.deepCharcoal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(4),
                    Text(
                      date,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.warmGrey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                amount,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.deepCharcoal,
                ),
              ),
            ],
          ),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Gap(6),
                    Text(
                      status.toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: Text(
                    'Rebook',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    side: const BorderSide(color: AppColors.neutral200),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
