import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:gap/gap.dart';
import 'package:weesh_mobile/features/pabili/application/cart_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final subtotal = ref.watch(cartSubtotalProvider);
    const deliveryFee = 49.0;
    final total = subtotal + deliveryFee;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WeeshAppBar(
        backgroundColor: AppColors.background,
        title: 'Your Cart',
      ),
      body: cartItems.isEmpty
          ? _buildEmptyState(context)
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.section, vertical: 16),
                    children: [
                      // Store Info
                      _buildStoreInfo(),
                      const Gap(24),

                      // Cart Items
                      Text(
                        'Order Items',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepCharcoal,
                        ),
                      ),
                      const Gap(12),
                      ...cartItems.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _CartItemCard(item: item),
                          )),
                      const Gap(20),

                      // Add More Items Button
                      _buildAddMoreButton(context),
                      const Gap(32),

                      // Note to Rider
                      _buildNoteToRider(),
                      const Gap(32),
                    ],
                  ),
                ),

                // Checkout Summary Bottom Sheet
                _buildCheckoutSummary(context, subtotal, deliveryFee, total),
              ],
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.section),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/illustrations/cart_empty.png',
              width: 250,
              height: 250,
            ),
            const Gap(32),
            Text(
              'Your cart is empty',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.deepCharcoal,
              ),
            ),
            const Gap(8),
            Text(
              'Looks like you haven\'t added any items to your cart yet.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppColors.warmGrey,
              ),
            ),
            const Gap(32),
            SizedBox(
              width: 200,
              child: FilledButton(
                onPressed: () => context.pop(),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Go Shopping'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Iconsax.shop, color: AppColors.secondary),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Pabili Request',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepCharcoal,
                  ),
                ),
                Text(
                  '1.2 km away • Delivers in 20 mins',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.warmGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMoreButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        HapticFeedback.lightImpact();
        context.pop();
      },
      icon: const Icon(Iconsax.add_circle),
      label: const Text('Add more items'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildNoteToRider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Note to Rider',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.deepCharcoal,
          ),
        ),
        const Gap(8),
        TextField(
          controller: _noteController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'e.g. Please check expiry dates carefully',
            hintStyle:
                TextStyle(color: AppColors.warmGrey.withValues(alpha: 0.6)),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutSummary(
      BuildContext context, double subtotal, double deliveryFee, double total) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          AppPadding.section, 24, AppPadding.section, 32),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 15, offset: Offset(0, -5))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Delivery address quick view
            Row(
              children: [
                const Icon(Iconsax.location, color: AppColors.primary, size: 20),
                const Gap(8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivering to',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 11, color: AppColors.warmGrey),
                      ),
                      Text(
                        'Home - 123 Sampaguita St.',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepCharcoal),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.warmGrey),
              ],
            ),
            const Gap(16),
            const Divider(color: AppColors.neutral200),
            const Gap(16),

            // Breakdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal',
                    style: GoogleFonts.plusJakartaSans(
                        color: AppColors.warmGrey, fontSize: 13)),
                Text('₱ ${subtotal.toStringAsFixed(2)}',
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                        color: AppColors.deepCharcoal)),
              ],
            ),
            const Gap(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Est. Delivery Fee',
                    style: GoogleFonts.plusJakartaSans(
                        color: AppColors.warmGrey, fontSize: 13)),
                Text('₱ ${deliveryFee.toStringAsFixed(2)}',
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                        color: AppColors.deepCharcoal)),
              ],
            ),
            const Gap(16),

            // Total Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepCharcoal)),
                Text('₱ ${total.toStringAsFixed(2)}',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const Gap(24),

            // Checkout Button
            FilledButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                context.push('/checkout', extra: _noteController.text);
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Proceed to Checkout',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemCard extends ConsumerWidget {
  const _CartItemCard({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 64,
                height: 64,
                color: AppColors.surfaceDim,
                child: const Icon(Iconsax.image, color: AppColors.warmGrey),
              ),
            ),
          ),
          const Gap(12),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.deepCharcoal,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.customization != null) ...[
                  const Gap(4),
                  Text(
                    item.customization!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.warmGrey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const Gap(8),
                Text(
                  '₱ ${item.price.toStringAsFixed(2)}',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          // Quantity Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceDim,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    if (item.quantity > 1) {
                      ref
                          .read(cartProvider.notifier)
                          .updateQuantity(item.lineItemKey, -1);
                    } else {
                      ref.read(cartProvider.notifier).removeItem(item.lineItemKey);
                    }
                  },
                  icon: const Icon(Icons.remove, size: 16, color: AppColors.deepCharcoal),
                  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  padding: EdgeInsets.zero,
                  tooltip: 'Decrease quantity',
                ),
                const Gap(4),
                Text(
                  item.quantity.toString(),
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.deepCharcoal,
                  ),
                ),
                const Gap(4),
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    ref.read(cartProvider.notifier).updateQuantity(item.lineItemKey, 1);
                  },
                  icon: const Icon(Icons.add, size: 16, color: AppColors.deepCharcoal),
                  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  padding: EdgeInsets.zero,
                  tooltip: 'Increase quantity',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
