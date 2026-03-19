import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/core/ui/weesh_card.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:gap/gap.dart';

// Mock data provider following Riverpod architecture rules
final activeActivitiesProvider =
    Provider<List<Map<String, dynamic>>>((ref) => [
          {
            'title': 'Parcel to Makati',
            'date': 'Today, 1:45 PM',
            'amount': '₱120.00',
            'status': 'In Transit',
            'icon': Iconsax.box,
            'color': AppColors.terracotta,
          },
          {
            'title': 'Pabili at Palengke',
            'date': 'Today, 2:30 PM',
            'amount': '₱350.00',
            'status': 'Pending',
            'icon': Iconsax.shopping_cart,
            'color': AppColors.secondary,
          },
        ]);

final pastActivitiesProvider =
    Provider<List<Map<String, dynamic>>>((ref) => [
          {
            'title': 'Ride to SM City',
            'date': 'Yesterday, 10:30 AM',
            'amount': '₱75.00',
            'status': 'Completed',
            'icon': Iconsax.car,
            'color': AppColors.primary,
          },
          {
            'title': 'Tricycle to Palengke',
            'date': '12 Oct, 8:15 AM',
            'amount': '₱50.00',
            'status': 'Completed',
            'icon': Icons.motorcycle,
            'color': AppColors.primary,
          },
          {
            'title': 'Ride to Plaza',
            'date': '10 Oct, 4:00 PM',
            'amount': '₱60.00',
            'status': 'Cancelled',
            'icon': Iconsax.car,
            'color': AppColors.error,
          },
        ]);

class ActivityHistoryScreen extends ConsumerWidget {
  const ActivityHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeItems = ref.watch(activeActivitiesProvider);
    final pastItems = ref.watch(pastActivitiesProvider);

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
            labelColor: AppColors.terracotta,
            unselectedLabelColor: AppColors.warmGrey,
            indicatorColor: AppColors.terracotta,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: GoogleFonts.plusJakartaSans(
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
            _buildList(context, activeItems),
            _buildList(context, pastItems),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Iconsax.activity, size: 48, color: AppColors.warmGrey),
            const Gap(12),
            Text(
              'No activities yet',
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.warmGrey,
                fontSize: 16,
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
        return _buildHistoryCard(
          context,
          title: item['title'] as String,
          date: item['date'] as String,
          amount: item['amount'] as String,
          status: item['status'] as String,
          icon: item['icon'] as IconData,
          iconColor: item['color'] as Color,
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
    final bool isCancelled = status.toLowerCase() == 'cancelled';
    final bool isPending =
        status.toLowerCase() == 'pending' || status.toLowerCase() == 'in transit';

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
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.deepCharcoal,
                      ),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.deepCharcoal,
                    ),
                  ),
                  const Gap(8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: GoogleFonts.plusJakartaSans(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (status.toLowerCase() == 'completed') ...[
            const Gap(16),
            const Divider(height: 1, color: AppColors.cardBorder),
            const Gap(12),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(
                  'Book Again',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.cardBorder),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
