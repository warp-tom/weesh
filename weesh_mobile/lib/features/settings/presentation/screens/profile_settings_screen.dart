import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:weesh_mobile/features/auth/application/auth_controller.dart';

class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ProfileSettingsScreen> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;
    final userName = user?.userMetadata?['full_name'] as String? ?? 'User';
    final userPhone = user?.phone ?? '+63 XXX XXX XXXX';

    return Scaffold(
      backgroundColor: AppColors.background,
      // ignore: weesh_no_generic_appbar
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.deepCharcoal,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.section),
        children: [
          const Gap(8),
          // Profile Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.heroBanner,
                  child: Icon(Iconsax.user, size: 32, color: AppColors.terracotta),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepCharcoal,
                        ),
                      ),
                      const Gap(2),
                      Text(
                        userPhone,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.warmGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.heroBanner,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(Iconsax.edit_2, size: 18, color: AppColors.terracotta),
                    onPressed: () => context.push('/edit_profile'),
                  ),
                ),
              ],
            ),
          ),

          const Gap(24),

          // Settings Section
          _buildSettingsItem(
            context,
            icon: Iconsax.location,
            title: 'Saved Places',
            onTap: () {},
          ),
          _buildSettingsItem(
            context,
            icon: Iconsax.card,
            title: 'Payment Methods',
            onTap: () => context.push('/weesh_wallet'),
          ),
          _buildSettingsItem(
            context,
            icon: Iconsax.heart,
            title: 'Emergency Contacts',
            onTap: () => context.push('/emergency_contacts'),
          ),
          _buildSettingsItem(
            context,
            icon: Iconsax.language_square,
            title: 'Language',
            trailing: Text(
              'English',
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.warmGrey,
                fontSize: 14,
              ),
            ),
            onTap: () {},
          ),
          _buildSettingsItem(
            context,
            icon: Iconsax.message_question,
            title: 'Help Center',
            onTap: () => context.push('/help_center'),
          ),

          const Gap(8),
          const Divider(color: AppColors.cardBorder, height: 1),
          const Gap(8),

          _buildSettingsItem(
            context,
            icon: Iconsax.moon,
            title: 'Dark Mode',
            trailing: Switch(
              value: _isDarkMode,
              onChanged: (value) {
                setState(() => _isDarkMode = value);
              },
              activeThumbColor: AppColors.terracotta,
            ),
            onTap: () => setState(() => _isDarkMode = !_isDarkMode),
          ),

          const Gap(8),
          const Divider(color: AppColors.cardBorder, height: 1),
          const Gap(8),

          _buildSettingsItem(
            context,
            icon: Iconsax.logout,
            title: 'Log Out',
            iconColor: AppColors.error,
            textColor: AppColors.error,
            showTrailing: false,
            onTap: () async {
              try {
                await ref.read(authControllerProvider.notifier).signOut();
                if (!context.mounted) return;
                context.go('/welcome');
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
          ),
          const Gap(24),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
    Color iconColor = AppColors.warmGrey,
    Color? textColor,
    bool showTrailing = true,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: (textColor ?? AppColors.heroBanner).withValues(alpha: textColor != null ? 0.1 : 1.0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: textColor ?? AppColors.terracotta, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: textColor ?? AppColors.deepCharcoal,
        ),
      ),
      trailing: trailing ??
          (showTrailing
              ? const Icon(Icons.chevron_right, color: AppColors.warmGrey)
              : null),
      onTap: onTap,
    );
  }
}
