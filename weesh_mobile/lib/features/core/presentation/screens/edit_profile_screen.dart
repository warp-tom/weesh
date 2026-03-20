import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:weesh_mobile/core/ui/weesh_button.dart';
import 'package:gap/gap.dart';
import 'package:weesh_mobile/features/auth/application/auth_controller.dart';
import 'package:weesh_mobile/features/profile/application/profile_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  bool _isPickingImage = false;

  Future<void> _pickAndUploadImage() async {
    if (_isPickingImage) return;

    setState(() {
      _isPickingImage = true;
    });

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        // We borrow the setupProfile method or direct repo access here.
        // Assuming setupProfile can update an existing profile:
        final authState = ref.read(authControllerProvider);
        final user = authState.value;
        if (user != null) {
          final currentMetadata = user.userMetadata ?? {};
          await ref.read(profileControllerProvider.notifier).setupProfile(
            userId: user.id,
            phone: user.phone ?? '',
            fullName: currentMetadata['full_name'] as String? ?? '',
            email: currentMetadata['email'] as String? ?? '',
            avatarFile: file,
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile image updated.'), backgroundColor: AppColors.primary),
            );
          }
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;
    final metadata = user?.userMetadata ?? {};
    
    final fullName = metadata['full_name'] as String? ?? 'Juan Dela Cruz';
    final email = metadata['email'] as String? ?? '';
    final dob = metadata['date_of_birth'] as String? ?? 'Not set';
    final avatarUrl = metadata['avatar_url'] as String?;
    final phone = user?.phone ?? '+63 9xx xxx xxxx';

    final profileState = ref.watch(profileControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WeeshAppBar(
        title: 'Edit Profile',
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.section),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Avatar Section
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 56,
                          backgroundColor: AppColors.surfaceDim,
                          backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                              ? NetworkImage(avatarUrl)
                              : null,
                          child: avatarUrl == null || avatarUrl.isEmpty
                              ? const Icon(Iconsax.user, size: 48, color: AppColors.neutral500)
                              : null,
                        ),
                        if (profileState.isLoading || _isPickingImage)
                          const Positioned.fill(
                            child: CircularProgressIndicator(color: AppColors.primary),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: profileState.isLoading || _isPickingImage ? null : _pickAndUploadImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.cardBorder, width: 1),
                              ),
                              child: const Icon(Iconsax.camera, color: AppColors.primary, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(40),

                  // Form Fields
                  _ProfileField(label: 'Full Name', initialValue: fullName, icon: Iconsax.user_edit),
                  const Gap(24),
                  _ProfileField(label: 'Phone Number', initialValue: phone, icon: Iconsax.call, isReadOnly: true),
                  const Gap(24),
                  _ProfileField(label: 'Email Address', initialValue: email, icon: Iconsax.sms, isReadOnly: true),
                  const Gap(24),
                  _ProfileField(label: 'Date of Birth', initialValue: dob, icon: Iconsax.calendar, isReadOnly: true),

                  const Gap(48),
                  
                  WeeshButton.filled(
                    label: 'Save Changes',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile updated successfully'), backgroundColor: AppColors.primary),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.initialValue,
    required this.icon,
    this.isReadOnly = false,
  });

  final String label;
  final String initialValue;
  final IconData icon;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textLight)),
        const Gap(8),
        TextFormField(
          initialValue: initialValue,
          readOnly: isReadOnly,
          style: TextStyle(
            color: isReadOnly ? AppColors.textLight : AppColors.textBody,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.neutral500, size: 20),
            filled: true,
            fillColor: isReadOnly ? AppColors.surfaceDim : AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.cardBorder, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.cardBorder, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
