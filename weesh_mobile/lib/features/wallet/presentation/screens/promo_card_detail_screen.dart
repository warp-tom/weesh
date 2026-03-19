import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:gap/gap.dart';

class PromoDetailScreen extends StatelessWidget {
  final String id;
  final Map<String, dynamic> extra;

  const PromoDetailScreen({
    super.key,
    required this.id,
    required this.extra,
  });

  @override
  Widget build(BuildContext context) {
    final title = extra['title'] as String;
    final subtitle = extra['subtitle'] as String;
    final color = Color(extra['color'] as int);
    final icon = IconData(
      extra['icon'] as int,
      fontFamily: extra['iconFontFamily'] as String?,
      fontPackage: extra['iconFontPackage'] as String?,
    );

    final textColor = color == AppColors.secondary ? Colors.black87 : Colors.white;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'promo_$id',
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                  ),
                  padding: const EdgeInsets.all(32),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(icon, color: textColor.withValues(alpha: 0.8), size: 64),
                        const Gap(16),
                        Text(
                          title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          subtitle,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            color: textColor.withValues(alpha: 0.8),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.section),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terms & Conditions',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepCharcoal,
                    ),
                  ),
                  const Gap(16),
                  Text(
                    '1. This voucher is valid for a single use only.\n2. Cannot be combined with other promotions.\n3. Applicable only on selected services.\n4. Weesh reserves the right to modify terms without prior notice.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppColors.neutral500,
                      height: 1.6,
                    ),
                  ),
                  const Gap(32),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.heroBanner,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        context.pop();
                      },
                      child: Text(
                        'Claim Voucher',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          color: AppColors.terracotta,
                        ),
                      ),
                    ),
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
