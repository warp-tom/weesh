import 'package:flutter/material.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class PaymentSelectorSheet extends StatefulWidget {
  const PaymentSelectorSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PaymentSelectorSheet(),
    );
  }

  @override
  State<PaymentSelectorSheet> createState() => _PaymentSelectorSheetState();
}

class _PaymentSelectorSheetState extends State<PaymentSelectorSheet> {
  String _selectedMethod = 'cash'; // 'cash', 'weeshpay', 'gcash'
  bool _needsChange = false;
  String _changeFor = '500';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.section),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Select Payment', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => context.pop(),
                )
              ],
            ),
            const Gap(16),

            // Cash on Delivery
            _PaymentOption(
              icon: Iconsax.money,
              title: 'Cash on Delivery',
              subtitle: 'Pay exact or request change',
              isSelected: _selectedMethod == 'cash',
              onTap: () => setState(() => _selectedMethod = 'cash'),
            ),
            
            // Contextual Content for Cash: Change Selector
            if (_selectedMethod == 'cash')
              Padding(
                padding: const EdgeInsets.only(left: 56, top: 12, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _needsChange,
                          fillColor: WidgetStateProperty.resolveWith(
                            (states) => states.contains(WidgetState.selected) ? AppColors.primary : null,
                          ),
                          onChanged: (val) => setState(() => _needsChange = val ?? false),
                        ),
                        const Text('I need change for:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    if (_needsChange)
                      Padding(
                        padding: const EdgeInsets.only(left: 48, right: 16),
                        child: DropdownButtonFormField<String>(
                          initialValue: _changeFor,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.surface,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(value: '100', child: Text('₱ 100.00')),
                            DropdownMenuItem(value: '500', child: Text('₱ 500.00')),
                            DropdownMenuItem(value: '1000', child: Text('₱ 1000.00')),
                          ],
                          onChanged: (val) => setState(() => _changeFor = val ?? '500'),
                        ),
                      ),
                  ],
                ),
              ),

            // WeeshPay Balance
            const Gap(12),
            _PaymentOption(
              icon: Iconsax.wallet_2,
              title: 'WeeshPay Balance',
              subtitle: 'Available: ₱ 2,450.00',
              isSelected: _selectedMethod == 'weeshpay',
              onTap: () => setState(() => _selectedMethod = 'weeshpay'),
            ),

            // GCash
            const Gap(12),
            _PaymentOption(
              icon: Iconsax.card,
              title: 'GCash',
              subtitle: 'Linked to 0917 ••• 1234',
              isSelected: _selectedMethod == 'gcash',
              onTap: () => setState(() => _selectedMethod = 'gcash'),
            ),

            const Gap(32),
            FilledButton(
              onPressed: () {
                // Save selection logic here
                context.pop();
              },
              child: const Text('Confirm Payment Method'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.neutral200, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.neutral200),
              ),
              child: Icon(icon, color: AppColors.deepCharcoal),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(subtitle, style: const TextStyle(color: AppColors.neutral500, fontSize: 13)),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
