import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:gap/gap.dart';

class RideInvoiceScreen extends StatelessWidget {
  const RideInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WeeshAppBar(
        title: 'Invoice Receipt',
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.section),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Receipt Header Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.neutral200),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 32,
                          backgroundColor: AppColors.success,
                          child: Icon(Icons.check, color: Colors.white, size: 32),
                        ),
                        const Gap(16),
                        Text('Payment Successful', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.neutral500)),
                        const Gap(8),
                        Text('₱ 145.00', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                        const Gap(24),
                        const Divider(color: AppColors.neutral200),
                        const Gap(24),
                        const _InvoiceRow(label: 'Date', value: 'Oct 24, 2024, 14:32'),
                        const Gap(12),
                        const _InvoiceRow(label: 'Transaction ID', value: 'WSH-8924184'),
                        const Gap(12),
                        const _InvoiceRow(label: 'Service', value: 'Weesh Ride (Motorcycle)'),
                        const Gap(12),
                        const _InvoiceRow(label: 'Payment Method', value: 'GCash (0917 ••• 1234)'),
                      ],
                    ),
                  ),

                  const Gap(32),

                  // Fare Breakdown
                  Text('Fare Breakdown', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const Gap(16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.neutral200),
                    ),
                    child: Column(
                      children: [
                        const _InvoiceRow(label: 'Base Fare', value: '₱ 50.00'),
                        const Gap(12),
                        const _InvoiceRow(label: 'Distance (4.2 km)', value: '₱ 65.00'),
                        const Gap(12),
                        const _InvoiceRow(label: 'Time (18 mins)', value: '₱ 25.00'),
                        const Gap(12),
                        const _InvoiceRow(label: 'Booking Fee', value: '₱ 15.00'),
                        const Gap(16),
                        const Divider(color: AppColors.neutral200),
                        const Gap(16),
                        const _InvoiceRow(label: 'Total Fare', value: '₱ 155.00', isBold: true),
                        const Gap(12),
                        const _InvoiceRow(label: 'Promo Code (WEESHFIRST)', value: '- ₱ 10.00', valueColor: AppColors.primary),
                        const Gap(16),
                        const Divider(color: AppColors.neutral200),
                        const Gap(16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Amount Paid', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('₱ 145.00', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Gap(32),
                  SizedBox(
                    height: 56,
                    child: FilledButton.icon(
                      onPressed: () => context.go('/home'),
                      icon: const Icon(Icons.home_filled),
                      label: const Text('Back to Home'),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _InvoiceRow extends StatelessWidget {
  const _InvoiceRow({required this.label, required this.value, this.isBold = false, this.valueColor});
  
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: AppColors.neutral500, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: valueColor ?? AppColors.deepCharcoal)),
      ],
    );
  }
}
