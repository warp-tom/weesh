import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:weesh_mobile/core/ui/weesh_slide_to_confirm.dart';
import 'package:weesh_mobile/features/wallet/presentation/widgets/payment_selector_sheet.dart';
import 'package:gap/gap.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _landmarkController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showPaymentSelector() {
    PaymentSelectorSheet.show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WeeshAppBar(title: 'Checkout'),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.section),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Address Section with Landmark Requirement
                  Text('Delivery Address', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const Gap(16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.neutral200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, color: AppColors.tertiary),
                            const Gap(12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Home', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('Brgy. San Jose, Block 4 Lot 12', style: TextStyle(color: AppColors.neutral500)),
                                ],
                              ),
                            ),
                            TextButton(onPressed: () {}, child: const Text('Change')),
                          ],
                        ),
                        const Gap(16),
                        const Divider(height: 1),
                        const Gap(16),
                        
                        // Provincial Context: Mandatory Landmark
                        const Text('Landmark (Required)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const Gap(8),
                        TextField(
                          controller: _landmarkController,
                          decoration: InputDecoration(
                            hintText: 'e.g., Tapat ng sari-sari store ni Aling Nena',
                            filled: true,
                            fillColor: AppColors.background,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const Gap(16),
                        const Text('Notes for Rider (Optional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const Gap(8),
                        TextField(
                          controller: _notesController,
                          decoration: InputDecoration(
                            hintText: 'e.g., Green gate, may aso po',
                            filled: true,
                            fillColor: AppColors.background,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Gap(32),

                  // Payment Method Row
                  Text('Payment Method', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const Gap(16),
                  InkWell(
                    onTap: _showPaymentSelector,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.neutral200),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('COD', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ),
                          const Gap(16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Cash on Delivery', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('Exact Amount Provided', style: TextStyle(color: AppColors.neutral500, fontSize: 13)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.neutral500),
                        ],
                      ),
                    ),
                  ),

                  const Gap(32),
                  
                  // Summary Breakdown
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.neutral200),
                    ),
                    child: Column(
                      children: [
                        const _SummaryRow(label: 'Subtotal (4 items)', value: '₱ 150.00'),
                        const Gap(8),
                        const _SummaryRow(label: 'Delivery Fee', value: '₱ 49.00'),
                        const Gap(8),
                        const _SummaryRow(label: 'Service Fee', value: '₱ 10.00'),
                        const Gap(16),
                        const Divider(height: 1),
                        const Gap(16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Payment', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('₱ 209.00', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Gap(80), // Bottom padding for slide to confirm
                ],
              ),
            ),
          )
        ],
      ),
      
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.section),
          child: WeeshSlideToConfirm(
            text: 'Slide to Place Order',
            onConfirm: () async {
              await Future.delayed(const Duration(milliseconds: 1500));
              if (!context.mounted) return;
              // Return to home or a success order screen
              context.go('/booking_confirmed');
            },
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.neutral500)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
