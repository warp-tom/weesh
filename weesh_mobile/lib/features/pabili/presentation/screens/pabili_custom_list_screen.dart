import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:weesh_mobile/core/ui/weesh_card.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:gap/gap.dart';

// Riverpod Provider for Shopping List State
class PabiliListNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => [];

  void addItem(String item) {
    if (item.trim().isNotEmpty && !state.contains(item.trim())) {
      state = [...state, item.trim()];
    }
  }

  void removeItem(String item) {
    state = state.where((element) => element != item).toList();
  }
}

final pabiliListProvider = NotifierProvider<PabiliListNotifier, List<String>>(() {
  return PabiliListNotifier();
});

class PabiliCustomListScreen extends ConsumerStatefulWidget {
  const PabiliCustomListScreen({super.key});

  @override
  ConsumerState<PabiliCustomListScreen> createState() => _PabiliCustomListScreenState();
}

class _PabiliCustomListScreenState extends ConsumerState<PabiliCustomListScreen> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();

  final List<String> _suggestedItems = [
    'Cooking Oil (1L)',
    'Eggs (1 Dozen)',
    'Rice (5 Kilos)',
    'Water (1 Gallon)',
    'Bread (Loaf)',
  ];

  @override
  void dispose() {
    _itemController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _addCurrentItem() {
    ref.read(pabiliListProvider.notifier).addItem(_itemController.text);
    _itemController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final shoppingList = ref.watch(pabiliListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WeeshAppBar(
        title: 'Shopping List',
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppPadding.section),
                children: [
                  Text('Quick Add', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const Gap(12),
                  SizedBox(
                    height: 48,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _suggestedItems.length,
                      separatorBuilder: (context, index) => const Gap(8),
                      itemBuilder: (context, index) {
                        final item = _suggestedItems[index];
                        return ActionChip(
                          label: Text(item),
                          backgroundColor: AppColors.sageGreen.withValues(alpha: 0.1),
                          side: const BorderSide(color: AppColors.sageGreen),
                          onPressed: () {
                            ref.read(pabiliListProvider.notifier).addItem(item);
                          },
                        );
                      },
                    ),
                  ),
                  const Gap(24),
                  
                  // Add Item Field
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _itemController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.surface,
                            hintText: 'Enter item to buy...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.neutral200),
                            ),
                          ),
                          onSubmitted: (_) => _addCurrentItem(),
                        ),
                      ),
                      const Gap(16),
                      FloatingActionButton(
                        onPressed: _addCurrentItem,
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const Gap(24),

                  // Palengke Upload (Provincial Feature)
                  Container(
                    padding: const EdgeInsets.all(AppPadding.section),
                    decoration: BoxDecoration(
                      color: AppColors.tertiary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.camera_alt_rounded, color: AppColors.tertiary, size: 36),
                        const Gap(12),
                        Text(
                          'Have a handwritten list?',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.tertiary,
                              ),
                        ),
                        const Gap(4),
                        const Text(
                          'Snap a photo of your physical Palengke list and our rider will handle the rest.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.neutral500, fontSize: 13),
                        ),
                        const Gap(16),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () {}, // Action to open camera
                            icon: const Icon(Icons.add_a_photo_outlined),
                            label: const Text('Upload List Image'),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.tertiary,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(32),

                  Text('Your Items (${shoppingList.length})', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const Gap(12),
                  if (shoppingList.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      alignment: Alignment.center,
                      child: const Text('Your shopping list is empty', style: TextStyle(color: AppColors.neutral500)),
                    )
                  else
                    ...shoppingList.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: WeeshCard(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          borderColor: AppColors.neutral200,
                        child: ListTile(
                          title: Text(item, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500, color: AppColors.deepCharcoal)),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: AppColors.error),
                            onPressed: () {
                              ref.read(pabiliListProvider.notifier).removeItem(item);
                            },
                          ),
                        ),
                      ),
                      );
                    }),
                ],
              ),
            ),

            // Bottom Confirm Container
            Container(
              padding: const EdgeInsets.all(AppPadding.section),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _budgetController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.background,
                      labelText: 'Est. Goods Cost (Optional)',
                      prefixText: '₱ ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const Gap(16),
                  FilledButton(
                    onPressed: shoppingList.isEmpty ? null : () {
                      context.push('/booking_confirmed');
                    },
                    child: const Text('Confirm Pabili'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
