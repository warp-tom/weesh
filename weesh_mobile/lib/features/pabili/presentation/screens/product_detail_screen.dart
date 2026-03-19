import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:gap/gap.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: AppColors.background,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: AppColors.surface,
                    child: BackButton(color: AppColors.deepCharcoal, onPressed: () => context.pop()),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: AppColors.neutral100,
                    child: Image.asset('assets/images/pancit_canton.png', fit: BoxFit.cover),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppPadding.section),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Pancit Canton (Original)',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Gap(16),
                          Text(
                            '₱ 20.00',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const Gap(12),
                      const Text(
                        'Classic Filipino instant noodles, perfect for a quick snack or meal. Comes with standard seasoning packets.',
                        style: TextStyle(color: AppColors.neutral500, height: 1.5),
                      ),
                      const Gap(32),
                      const Text('Special Instructions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Gap(12),
                      TextField(
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'e.g. Please check expiration date...',
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.neutral200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.neutral200),
                          ),
                        ),
                      ),
                      const Gap(120), // Bottom padding for checkout bar
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Fixed Bottom Checkout Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(AppPadding.section),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    // Quantity Selector
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.neutral200),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (_quantity > 1) setState(() => _quantity--);
                            },
                            color: _quantity > 1 ? AppColors.deepCharcoal : AppColors.neutral200,
                          ),
                          Text('$_quantity', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.add),
                            color: AppColors.primary,
                            onPressed: () {
                              setState(() => _quantity++);
                            },
                          ),
                        ],
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: FilledButton(
                          onPressed: () => context.pop(),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text('Add to Cart • ₱ ${(_quantity * 20).toStringAsFixed(2)}'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
