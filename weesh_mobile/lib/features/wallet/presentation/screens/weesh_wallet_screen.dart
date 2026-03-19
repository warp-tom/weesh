import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

final mockBalanceProvider = StateProvider<double>((ref) => 1250.00);

class WeeshWalletScreen extends ConsumerWidget {
  const WeeshWalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(mockBalanceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      // ignore: weesh_no_generic_appbar
      appBar: AppBar(
        title: Text(
          'Wallet',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.deepCharcoal,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Balance Card — with animated glow
          Container(
            margin: const EdgeInsets.all(AppPadding.section),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.terracotta,
                  Color(0xFFB04A3C),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Balance',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(8),
                Text(
                  '₱${balance.toStringAsFixed(2)}',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.section),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  context,
                  title: 'Top Up',
                  icon: Iconsax.wallet_add,
                  onTap: () => context.push('/cash_in'),
                ),
                _buildActionButton(
                  context,
                  title: 'Send',
                  icon: Iconsax.send_2,
                  onTap: () {},
                ),
                _buildActionButton(
                  context,
                  title: 'WeeshPay',
                  icon: Iconsax.card,
                  onTap: () => context.push('/weesh_pay_dashboard'),
                ),
                _buildActionButton(
                  context,
                  title: 'Receive',
                  icon: Iconsax.empty_wallet_add,
                  onTap: () {},
                ),
              ],
            ),
          ),

          const Gap(32),

          // Promo Cards
          SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.section),
              children: [
                _buildPromoCard(
                  context,
                  id: 'promo_1',
                  title: '20% Off Rides',
                  subtitle: 'Valid until Dec 31',
                  color: AppColors.secondary,
                  icon: Iconsax.discount_shape,
                ),
                const Gap(16),
                _buildPromoCard(
                  context,
                  id: 'promo_2',
                  title: 'Free Delivery',
                  subtitle: 'For new users',
                  color: AppColors.primary,
                  icon: Iconsax.box,
                ),
              ],
            ),
          ),

          const Gap(32),

          // Recent Transactions
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppPadding.section, 24, AppPadding.section, 16),
                    child: Text(
                      'Recent Transactions',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepCharcoal,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.section),
                      itemCount: _mockTransactions.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        color: AppColors.cardBorder,
                      ),
                      itemBuilder: (context, index) {
                        final tx = _mockTransactions[index];
                        return _buildTransactionItem(
                          context,
                          title: tx['title'] as String,
                          date: tx['date'] as String,
                          amount: tx['amount'] as String,
                          isDeduction: tx['isDeduction'] as bool,
                          icon: tx['icon'] as IconData,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.terracotta.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.terracotta, size: 24),
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
      ),
    );
  }

  Widget _buildPromoCard(
    BuildContext context, {
    required String id,
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    // Determine a darker text color for light backgrounds
    final textColor = color == AppColors.secondary ? Colors.black87 : Colors.white;

    return GestureDetector(
      onTap: () {
        context.push('/promo_detail/$id', extra: {
          'title': title,
          'subtitle': subtitle,
          'color': color.toARGB32(),
          'icon': icon.codePoint,
          'iconFontFamily': icon.fontFamily,
          'iconFontPackage': icon.fontPackage,
        });
      },
      child: Hero(
        tag: 'promo_$id',
        child: Container(
          width: 240,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppShadows.soft,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: textColor.withValues(alpha: 0.8), size: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: textColor.withValues(alpha: 0.8),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context, {
    required String title,
    required String date,
    required String amount,
    required bool isDeduction,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.heroBanner,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.terracotta, size: 20),
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.deepCharcoal,
                  ),
                ),
                const Gap(2),
                Text(
                  date,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.warmGrey,
                    fontSize: 12,
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
              color: isDeduction ? AppColors.deepCharcoal : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  static final List<Map<String, dynamic>> _mockTransactions = [
    {
      'title': 'Ride to SM City',
      'date': 'Today, 2:30 PM',
      'amount': '-₱75.00',
      'isDeduction': true,
      'icon': Iconsax.car,
    },
    {
      'title': 'Cash In via GCash',
      'date': 'Yesterday, 10:00 AM',
      'amount': '+₱500.00',
      'isDeduction': false,
      'icon': Iconsax.wallet_add,
    },
    {
      'title': 'Pabili at Palengke',
      'date': 'Mon, 9:15 AM',
      'amount': '-₱350.00',
      'isDeduction': true,
      'icon': Iconsax.shopping_cart,
    },
    {
      'title': 'Parcel to Makati',
      'date': 'Sun, 1:45 PM',
      'amount': '-₱120.00',
      'isDeduction': true,
      'icon': Iconsax.box,
    },
  ];
}
