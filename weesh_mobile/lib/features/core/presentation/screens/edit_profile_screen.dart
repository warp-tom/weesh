import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:gap/gap.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                        const CircleAvatar(
                          radius: 56,
                          backgroundColor: AppColors.neutral200,
                          child: Icon(Iconsax.user, size: 48, color: AppColors.neutral500),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.background, width: 3),
                            ),
                            child: const Icon(Iconsax.camera, color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(32),

                  // Form Fields
                  const _ProfileField(label: 'Full Name', initialValue: 'Juan Dela Cruz', icon: Iconsax.user_edit),
                  const Gap(24),
                  const _ProfileField(label: 'Phone Number', initialValue: '+63 917 123 4567', icon: Iconsax.call, isReadOnly: true), // Phone usually bound to Auth
                  const Gap(24),
                  const _ProfileField(label: 'Email Address', initialValue: 'juan.delacruz@example.com', icon: Iconsax.sms),
                  const Gap(24),
                  const _ProfileField(label: 'Date of Birth', initialValue: 'Oct 24, 1995', icon: Iconsax.calendar),

                  const Gap(48),
                  
                  FilledButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully')));
                    },
                    child: const Text('Save Changes'),
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
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.neutral500)),
        const Gap(8),
        TextFormField(
          initialValue: initialValue,
          readOnly: isReadOnly,
          style: TextStyle(
            color: isReadOnly ? AppColors.neutral500 : AppColors.deepCharcoal,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.neutral500),
            filled: true,
            fillColor: isReadOnly ? AppColors.neutral100 : AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
