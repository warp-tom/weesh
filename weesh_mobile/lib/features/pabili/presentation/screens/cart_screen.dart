import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:gap/gap.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WeeshAppBar(
        title: 'Review Cart',
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppPadding.section),
              children: [
                Row(
                  children: [
                    const Icon(Iconsax.shop, color: AppColors.primary),
                    const Gap(8),
                    Text('Aling Nena\'s Sari-Sari', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                const Gap(16),
                const _CartItem(name: 'Pancit Canton (Original)', price: 40.0, quantity: 2),
                const Gap(16),
                const _CartItem(name: 'Cobra Energy Drink', price: 25.0, quantity: 1),
                const Gap(16),
                const _CartItem(name: 'Gardenia Loaf Bread', price: 85.0, quantity: 1),
                const Gap(32),
                
                // Add More Items
                OutlinedButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add more items'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          
          // Checkout Summary Bottom Sheet
          Container(
            padding: const EdgeInsets.all(AppPadding.section),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal', style: TextStyle(color: AppColors.neutral500)),
                      Text('₱ 150.00', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Gap(8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Est. Delivery Fee', style: TextStyle(color: AppColors.neutral500)),
                      Text('₱ 49.00', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Gap(16),
                  const Divider(color: AppColors.neutral200),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      Text('₱ 199.00', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Gap(24),
                  FilledButton(
                    onPressed: () {
                      context.push('/checkout');
                    },
                    child: const Text('Proceed to Checkout'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  const _CartItem({required this.name, required this.price, required this.quantity});
  final String name;
  final double price;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.neutral100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Iconsax.image, color: AppColors.neutral500),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
              const Gap(4),
              Text('₱ ${price.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const Gap(12),
        Text('${quantity}x', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
