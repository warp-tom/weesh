import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:weesh_mobile/core/theme/constants.dart';

/// The canonical AppBar for the Weesh Design System.
/// Enforces consistent bold typography, high-contrast colors, 
/// and ensures an "escape hatch" (Back Button) is always available 
/// with integrated HapticFeedback.
class WeeshAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Color? backgroundColor;

  const WeeshAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: weesh_no_generic_appbar
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 0, // Prevent Material 3 dark scroll tint
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Iconsax.arrow_left_2_copy, color: AppColors.deepCharcoal),
              tooltip: 'Back', // Add semantic label for screen readers
              onPressed: () {
                HapticFeedback.lightImpact(); // Sensory layer
                if (onBackPressed != null) {
                  onBackPressed!();
                } else if (context.canPop()) {
                  context.pop();
                }
              },
            )
          : null,
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w800, // Anchored typography
          color: AppColors.deepCharcoal,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
