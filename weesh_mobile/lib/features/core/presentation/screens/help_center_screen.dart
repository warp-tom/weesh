import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:gap/gap.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WeeshAppBar(
        title: 'Help Center',
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.section),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Search
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for help...',
                      prefixIcon: const Icon(Iconsax.search_normal),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const Gap(32),

                  // Topics Grid
                  Text('Topics', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const Gap(16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.5,
                    children: const [
                      _TopicCard(icon: Iconsax.car, title: 'Rides'),
                      _TopicCard(icon: Iconsax.box, title: 'Parcels'),
                      _TopicCard(icon: Iconsax.shop, title: 'Pabili'),
                      _TopicCard(icon: Iconsax.wallet_2, title: 'WeeshPay'),
                      _TopicCard(icon: Iconsax.shield_tick, title: 'Safety'),
                      _TopicCard(icon: Iconsax.user, title: 'Account'),
                    ],
                  ),
                  const Gap(32),

                  // FAQ
                  Text('Frequently Asked Questions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const Gap(16),
                  const _FaqTile(
                    question: 'How do I change my exact change request for COD?',
                    answer: 'You can select the exact change amount during checkout by tapping the Payment Method and choosing Cash on Delivery. A dropdown will appear allowing you to select ₱100, ₱500, or ₱1000.',
                  ),
                  const _FaqTile(
                    question: 'What if the rider cannot find my landmark?',
                    answer: 'You can use the in-app chat or call feature once a rider accepts your booking. They are required to contact you if they have trouble locating your pin.',
                  ),
                  const Gap(120),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        icon: const Icon(Iconsax.message_text, color: Colors.white),
        label: const Text('Chat with Support', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary),
          const Gap(8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.question, required this.answer});
  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.deepCharcoal)),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(answer, style: const TextStyle(color: AppColors.neutral500, height: 1.5)),
          ),
        ],
      ),
    );
  }
}
