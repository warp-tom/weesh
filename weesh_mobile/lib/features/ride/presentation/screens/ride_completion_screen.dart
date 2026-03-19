import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:gap/gap.dart';

class RideCompletionScreen extends StatefulWidget {
  const RideCompletionScreen({super.key});

  @override
  State<RideCompletionScreen> createState() => _RideCompletionScreenState();
}

class _RideCompletionScreenState extends State<RideCompletionScreen> {
  int _selectedTip = 0;
  int _rating = 0;
  final List<String> _selectedTags = [];

  final List<int> _tipOptions = [20, 50, 100];
  final List<String> _feedbackTags = [
    'Safe driver',
    'Clean car',
    'Great music',
    'Polite',
    'On time',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppPadding.section),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Gap(48),
              const Icon(
                Icons.check_circle,
                size: 80,
                color: AppColors.primary,
              ),
              const Gap(16),
              Text(
                'Ride Finished',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Gap(8),
              Text(
                '₱ 85.00',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Gap(48),

              // Rating
              Text(
                'How was your ride?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Gap(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconButton(
                      icon: Icon(
                        index < _rating ? Iconsax.star_1 : Iconsax.star,
                        color: AppColors.secondary,
                        size: 36,
                      ),
                      onPressed: () {
                        setState(() {
                          _rating = index + 1;
                        });
                      },
                    ),
                  );
                }),
              ),
              
              if (_rating > 0) ...[
                const Gap(24),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.center,
                  children: _feedbackTags.map((tag) {
                    final isSelected = _selectedTags.contains(tag);
                    return ActionChip(
                      label: Text(tag, style: TextStyle(color: isSelected ? AppColors.primary : AppColors.textBody)),
                      backgroundColor: isSelected ? AppColors.sageGreen.withValues(alpha: 0.2) : AppColors.surface,
                      side: BorderSide(color: isSelected ? AppColors.primary : AppColors.neutral200),
                      onPressed: () {
                        setState(() {
                          if (isSelected) {
                            _selectedTags.remove(tag);
                          } else {
                            _selectedTags.add(tag);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],

              const Gap(48),

              // Tip Selector
              Text(
                'Add a tip for Kuya Cardo?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Gap(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ..._tipOptions.map((amount) {
                    final isSelected = _selectedTip == amount;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ActionChip(
                        label: Text('₱$amount', style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? AppColors.primary : AppColors.textBody)),
                        backgroundColor: isSelected ? AppColors.sageGreen.withValues(alpha: 0.2) : AppColors.surface,
                        side: BorderSide(color: isSelected ? AppColors.primary : AppColors.neutral200),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        onPressed: () {
                          setState(() => _selectedTip = isSelected ? 0 : amount);
                        },
                      ),
                    );
                  }),
                  ActionChip(
                    label: const Text('Custom', style: TextStyle(fontWeight: FontWeight.bold)),
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.neutral200),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    onPressed: () {},
                  ),
                ],
              ),
              const Gap(48),

              FilledButton(
                onPressed: () {
                  context.go('/home'); 
                },
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
