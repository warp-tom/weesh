import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:weesh_mobile/features/wallet/application/wallet_provider.dart';
import 'package:weesh_mobile/core/ui/weesh_skeleton.dart';

class WeeshWalletScreen extends ConsumerWidget {
  const WeeshWalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Bug 6: Show SnackBar when top-up (or wallet load) fails
    ref.listen<AsyncValue<dynamic>>(walletAccountNotifierProvider, (_, next) {
      next.whenOrNull(
        error: (err, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                err.toString().replaceFirst('Exception: ', ''),
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      );
    });

    final walletState = ref.watch(walletAccountNotifierProvider);
    final transactionsState = ref.watch(walletTransactionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: walletState.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(child: Text('Error: $err', style: GoogleFonts.inter(color: AppColors.error))),
        data: (wallet) {
          final balance = wallet?.balance ?? 0;
          return CustomScrollView(
            slivers: [
              // ─── Gradient Balance Header ───
              SliverToBoxAdapter(
                child: _buildBalanceHeader(context, balance),
              ),

              // ─── Quick Actions ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.section,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (kDebugMode)
                        _buildActionButton(
                          context,
                          title: 'Top-Up\n(Mock)',
                          icon: Iconsax.wallet_add,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            ref.read(walletAccountNotifierProvider.notifier).topUp(10000, 'GCash Mock (Auto)');
                          },
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
              ),

              // ─── Payment Methods Section ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.section,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Methods',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepCharcoal,
                        ),
                      ),
                      const Gap(12),
                      _buildPaymentMethodTile(
                        context,
                        title: 'GCash',
                        subtitle: 'Link your GCash account',
                        color: const Color(0xFF007DFE),
                        icon: Iconsax.mobile,
                        isLinked: false,
                        onTap: () => context.push('/gcash_link'),
                      ),
                      const Gap(8),
                      _buildPaymentMethodTile(
                        context,
                        title: 'Cash',
                        subtitle: 'Pay with cash on delivery',
                        color: AppColors.primary,
                        icon: Iconsax.money,
                        isLinked: true,
                        onTap: () {},
                      ),
                      const Gap(8),
                      _buildPaymentMethodTile(
                        context,
                        title: 'WeeshPay',
                        subtitle: '₱${(balance / 100).toStringAsFixed(2)} available',
                        color: AppColors.secondary,
                        icon: Iconsax.card,
                        isLinked: true,
                        onTap: () => context.push('/weesh_pay_dashboard'),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: Gap(24)),

              // ─── Promo Cards ───
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.section,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Promos & Vouchers',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.deepCharcoal,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.push('/promo_vouchers'),
                            child: Text(
                              'See All',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 140,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.section,
                        ),
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
                          const Gap(16),
                          _buildPromoCard(
                            context,
                            id: 'promo_3',
                            title: '₱50 Cashback',
                            subtitle: 'Min. ₱200 top up',
                            color: const Color(0xFF007DFE),
                            icon: Iconsax.wallet_add,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SliverToBoxAdapter(child: Gap(24)),

              // ─── Recent Transactions ───
              SliverToBoxAdapter(
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
                          AppPadding.section, 24, AppPadding.section, 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Transactions',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.deepCharcoal,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'View All',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      transactionsState.when(
                        loading: () => ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: AppPadding.section),
                          itemCount: 3,
                          separatorBuilder: (_, __) => const Gap(12),
                          itemBuilder: (_, __) => WeeshSkeleton.listTile(),
                        ),
                        error: (err, stack) => Padding(
                          padding: const EdgeInsets.all(AppPadding.section),
                          child: Text('Error loading transactions: $err', style: GoogleFonts.inter(color: AppColors.error)),
                        ),
                         data: (transactions) {
                          if (transactions.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/illustrations/wallet_success.png',
                                    width: 140,
                                    height: 140,
                                  ),
                                  const Gap(16),
                                  Text('No transactions yet',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.deepCharcoal,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    )),
                                  const Gap(6),
                                  Text('Top up your wallet to get started.',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textLight,
                                      fontSize: 13,
                                    )),
                                ],
                              ),
                            );
                          }
                          return Column(
                            children: transactions.map((tx) {
                              final isOutflow = tx.type != 'top_up' && tx.type != 'refund';
                              final prefix = isOutflow ? '-' : '+';
                              return _buildTransactionItem(
                                context,
                                title: tx.title,
                                date: '${tx.createdAt.month}/${tx.createdAt.day}/${tx.createdAt.year}',
                                // Bug 2 fix: amount is in centavos (int), divide by 100 for PHP display
                                amount: '$prefix₱${(tx.amount / 100).toStringAsFixed(2)}',
                                isDeduction: isOutflow,
                                icon: isOutflow ? Iconsax.shopping_cart : Iconsax.wallet_add,
                              );
                            }).toList(),
                          );
                        },
                      ),
                      const Gap(40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBalanceHeader(BuildContext context, int balance) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 28,
        left: AppPadding.section,
        right: AppPadding.section,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xFF1F352C)],
        ),
        borderRadius:
            BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title bar
          Text(
            'Wallet',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Gap(24),
          // Balance section
          Text(
            'Available Balance',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₱${(balance / 100).toStringAsFixed(2)}',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Iconsax.eye,
                      size: 16,
                      color: Colors.white70,
                    ),
                    const Gap(6),
                    Text(
                      'Show',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required bool isLinked,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepCharcoal,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppColors.warmGrey,
                    ),
                  ),
                ],
              ),
            ),
            if (isLinked)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Active',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.warmGrey,
              ),
          ],
        ),
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
              color: AppColors.surface,
              border:
                  Border.all(color: AppColors.cardBorder, width: 1.0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
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
    final textColor =
        color == AppColors.secondary ? Colors.black87 : Colors.white;

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
          width: 220,
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
              Icon(icon,
                  color: textColor.withValues(alpha: 0.8), size: 32),
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
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: AppPadding.section,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceDim,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.deepCharcoal, size: 20),
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
              color:
                  isDeduction ? AppColors.deepCharcoal : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
