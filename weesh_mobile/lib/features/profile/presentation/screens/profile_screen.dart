import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/features/auth/application/auth_controller.dart';
import 'package:weesh_mobile/features/profile/application/profile_controller.dart';
import 'package:weesh_mobile/features/profile/data/repositories/supabase_profile_repository.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

/// Provider that fetches the current user's profile from the `users` table.
final userProfileProvider =
    FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final user = ref.watch(authControllerProvider).value;
  if (user == null) return null;
  return ref.read(profileRepositoryProvider).getProfile(user.id);
});

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  File? _pendingAvatar;

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() => _pendingAvatar = File(picked.path));

    final user = ref.read(authControllerProvider).value;
    if (user == null) return;

    // Read existing profile data so we don't overwrite name/phone
    final existingProfile = ref.read(userProfileProvider).value;
    final existingName = existingProfile?['full_name'] as String? ??
        user.userMetadata?['full_name'] as String? ?? '';
    final existingPhone = existingProfile?['phone'] as String? ?? user.phone ?? '';

    await ref.read(profileControllerProvider.notifier).setupProfile(
          userId: user.id,
          phone: existingPhone,
          fullName: existingName,
          avatarFile: _pendingAvatar,
        );

    // Refresh profile data
    ref.invalidate(userProfileProvider);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final user = authState.value;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ─── Header with avatar ───
          SliverToBoxAdapter(
            child: _buildProfileHeader(context, user, profileAsync),
          ),

          // ─── Settings sections ───
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.section,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(24),
                  _buildSectionTitle('Account'),
                  const Gap(8),
                  _buildSettingsTile(
                    icon: Iconsax.user_edit,
                    title: 'Edit Profile',
                    onTap: () => context.push('/profile_setup'),
                  ),
                  _buildSettingsTile(
                    icon: Iconsax.card,
                    title: 'Payment Methods',
                    subtitle: 'GCash, Cash, WeeshPay',
                    onTap: () => context.push('/weesh_wallet'),
                  ),
                  _buildSettingsTile(
                    icon: Iconsax.location,
                    title: 'Saved Places',
                    subtitle: 'Home, Work, Favorites',
                    onTap: () {},
                  ),
                  const Gap(24),
                  _buildSectionTitle('Preferences'),
                  const Gap(8),
                  _buildSettingsTile(
                    icon: Iconsax.notification,
                    title: 'Notifications',
                    onTap: () => context.push('/notifications'),
                  ),
                  _buildSettingsTile(
                    icon: Iconsax.shield_tick,
                    title: 'Privacy & Security',
                    onTap: () {},
                  ),
                  _buildSettingsTile(
                    icon: Iconsax.language_circle,
                    title: 'Language',
                    subtitle: 'English',
                    onTap: () {},
                  ),
                  const Gap(24),
                  _buildSectionTitle('Support'),
                  const Gap(8),
                  _buildSettingsTile(
                    icon: Iconsax.message_question,
                    title: 'Help Center',
                    onTap: () {},
                  ),
                  _buildSettingsTile(
                    icon: Iconsax.info_circle,
                    title: 'About Weesh',
                    subtitle: 'Version 1.0.0',
                    onTap: () {},
                  ),
                  const Gap(16),
                  // ─── Logout Button ───
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await ref
                            .read(authControllerProvider.notifier)
                            .signOut();
                        if (context.mounted) context.go('/login');
                      },
                      icon: const Icon(Iconsax.logout, size: 18),
                      label: Text(
                        'Sign Out',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const Gap(40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    User? user,
    AsyncValue<Map<String, dynamic>?> profileAsync,
  ) {
    final profile = profileAsync.valueOrNull;
    final fullName =
        profile?['full_name'] as String? ??
        user?.userMetadata?['full_name'] as String? ??
        'Weesh User';
    final phone = profile?['phone'] as String? ?? user?.phone ?? '';
    final avatarUrl = profile?['avatar_url'] as String?;
    final city = profile?['city'] as String?;
    final province = profile?['province'] as String?;
    final location = [city, province]
        .where((e) => e != null && e.isNotEmpty)
        .join(', ');

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 24,
        left: AppPadding.section,
        right: AppPadding.section,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xFF1F352C)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
        children: [
          // Title bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () => context.push('/settings'),
                icon: const Icon(Iconsax.setting_2, color: Colors.white70),
              ),
            ],
          ),
          const Gap(20),
          // Avatar
          GestureDetector(
            onTap: _pickAvatar,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.white24,
                  backgroundImage: _pendingAvatar != null
                      ? FileImage(_pendingAvatar!) as ImageProvider
                      : avatarUrl != null
                          ? NetworkImage(avatarUrl) as ImageProvider
                          : null,
                  child: (_pendingAvatar == null && avatarUrl == null)
                      ? const Icon(
                          Iconsax.user,
                          size: 40,
                          color: Colors.white70,
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Iconsax.camera,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(16),
          // Name
          Text(
            fullName,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Gap(4),
          // Phone
          Text(
            phone,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
            if (location.isNotEmpty) ...[
              const Gap(4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Iconsax.location, size: 14, color: Colors.white54),
                  const Gap(4),
                  Text(
                    location,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ],
    ),
  );
}

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.deepCharcoal,
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceDim,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: AppColors.primary),
            ),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepCharcoal,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppColors.warmGrey,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.warmGrey,
            ),
          ],
        ),
      ),
    );
  }
}
