import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:weesh_mobile/core/ui/weesh_card.dart';
import 'package:gap/gap.dart';

class WeeshPayDashboardScreen extends StatelessWidget {
  const WeeshPayDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WeeshAppBar(
        title: 'WeeshPay',
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.section),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Floating Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppShadows.soft,
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.terracotta],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WeeshPay Balance',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    '₱1,250.00',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(32),

            // Fintech Operations Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOperationIcon(
                  context,
                  title: 'Scan QR',
                  icon: Icons.qr_code_scanner_rounded,
                  color: AppColors.primary,
                ),
                _buildOperationIcon(
                  context,
                  title: 'Send',
                  icon: Iconsax.send_2,
                  color: AppColors.secondary,
                ),
                _buildOperationIcon(
                  context,
                  title: 'Receive',
                  icon: Icons.arrow_downward_rounded,
                  color: AppColors.terracotta,
                ),
                _buildOperationIcon(
                  context,
                  title: 'Bills',
                  icon: Icons.receipt_long_rounded,
                  color: AppColors.warmGrey,
                ),
              ],
            ),
            const Gap(32),

            // Fast Chips (Quick Send)
            Text(
              'Quick Send',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.deepCharcoal,
              ),
            ),
            const Gap(16),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildQuickSendAvatar(name: 'Maria', initial: 'M'),
                  _buildQuickSendAvatar(name: 'Juan', initial: 'J'),
                  _buildQuickSendAvatar(name: 'Anna', initial: 'A'),
                  _buildQuickSendAvatar(name: 'David', initial: 'D'),
                  _buildQuickSendAvatar(name: 'New', initial: '+', isAdd: true),
                ],
              ),
            ),
            const Gap(32),

            // Visual Timeline
            Text(
              'Recent Activity',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.deepCharcoal,
              ),
            ),
            const Gap(16),
            WeeshCard(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  _buildTimelineItem(
                    title: 'Payment to Juan',
                    time: 'Today, 2:45 PM',
                    amount: '-₱150.00',
                    isExpense: true,
                  ),
                  const Divider(indent: 56, endIndent: 16, height: 1),
                  _buildTimelineItem(
                    title: 'Top Up via Gcash',
                    time: 'Yesterday, 9:20 AM',
                    amount: '+₱1,000.00',
                    isExpense: false,
                  ),
                  const Divider(indent: 56, endIndent: 16, height: 1),
                  _buildTimelineItem(
                    title: 'Starbucks Coffee',
                    time: 'Sep 21, 8:15 AM',
                    amount: '-₱180.00',
                    isExpense: true,
                  ),
                ],
              ),
            ),
            const Gap(32),
          ],
        ),
      ),
    );
  }

  Widget _buildOperationIcon(BuildContext context, {required String title, required IconData icon, required Color color}) {
    return Column(
      children: [
        Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const Gap(8),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.deepCharcoal,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickSendAvatar({required String name, required String initial, bool isAdd = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: isAdd ? AppColors.surface : AppColors.heroBanner,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.cardBorder, width: isAdd ? 2 : 1),
            ),
            child: Center(
              child: Text(
                initial,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isAdd ? AppColors.neutral500 : AppColors.primary,
                ),
              ),
            ),
          ),
          const Gap(8),
          Text(
            name,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.deepCharcoal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({required String title, required String time, required String amount, required bool isExpense}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isExpense ? AppColors.error.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isExpense ? Icons.arrow_outward_rounded : Icons.south_west_rounded,
          color: isExpense ? AppColors.error : AppColors.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.bold,
          color: AppColors.deepCharcoal,
        ),
      ),
      subtitle: Text(
        time,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          color: AppColors.warmGrey,
        ),
      ),
      trailing: Text(
        amount,
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: isExpense ? AppColors.deepCharcoal : AppColors.primary,
        ),
      ),
    );
  }
}
