import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:weesh_mobile/core/ui/weesh_card.dart';

class PabiliStoreSelectionScreen extends StatelessWidget {
  const PabiliStoreSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WeeshAppBar(
        title: 'Pabili',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppPadding.section),
            child: SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0)),
                  onTap: () {
                    controller.openView();
                  },
                  onChanged: (_) {
                    controller.openView();
                  },
                  leading: const Icon(Iconsax.search_normal_1, color: AppColors.neutral500),
                  hintText: 'Search for a store or item...',
                  elevation: const WidgetStatePropertyAll<double>(0),
                  backgroundColor: const WidgetStatePropertyAll<Color>(AppColors.surface),
                  shape: WidgetStatePropertyAll<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppColors.neutral200),
                    ),
                  ),
                );
              },
              suggestionsBuilder: (BuildContext context, SearchController controller) {
                return List<ListTile>.generate(5, (int index) {
                  final String item = 'Suggested result $index';
                  return ListTile(
                    title: Text(item),
                    onTap: () {
                      controller.closeView(item);
                    },
                  );
                });
              },
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.section),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildStoreCard(
                  context,
                  title: 'Palengke',
                  subtitle: 'Wet Market',
                  color: AppColors.primary,
                  icon: Iconsax.shop,
                ),
                _buildStoreCard(
                  context,
                  title: 'Pharmacy',
                  subtitle: 'Meds & Health',
                  color: AppColors.secondary,
                  icon: Iconsax.health,
                ),
                _buildStoreCard(
                  context,
                  title: 'Convenience',
                  subtitle: 'Quick Snacks',
                  color: AppColors.tertiary,
                  icon: Iconsax.building,
                ),
                _buildStoreCard(
                  context,
                  title: 'Hardware',
                  subtitle: 'Tools & Supplies',
                  color: AppColors.sageGreen,
                  icon: Iconsax.setting,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return WeeshCard(
      elevation: 1, // Triggers AppShadows.soft glow
      onTap: () {
        context.push('/pabili_custom_list');
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.deepCharcoal,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.warmGrey,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
