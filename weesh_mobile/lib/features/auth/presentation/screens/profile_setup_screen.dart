import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/features/auth/application/auth_controller.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:weesh_mobile/features/profile/application/profile_controller.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() =>
      _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  File? _selectedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // ─── Image picking ────────────────────────────────────────────────────────

  Future<void> _pickImage(ImageSource source) async {
    // Close the bottom sheet before picking
    Navigator.of(context).pop();

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (picked == null) return;

      setState(() {
        _selectedImage = File(picked.path);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not pick image: $e')),
      );
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.card),
        ),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a photo'),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            if (_selectedImage != null)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Remove photo',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() => _selectedImage = null);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _completeSetup() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name')),
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    try {
      final authState = ref.read(authControllerProvider);
      final user = authState.value;

      if (user != null) {
        // Delegate profile setup and image upload to the controller
        await ref.read(profileControllerProvider.notifier).setupProfile(
              userId: user.id,
              phone: user.phone ?? '',
              fullName: name,
              email: _emailController.text.trim().isNotEmpty
                  ? _emailController.text.trim()
                  : null,
              avatarFile: _selectedImage,
            );
            
        // Check if the controller hit an error during the guard
        final controllerState = ref.read(profileControllerProvider);
        if (controllerState.hasError) {
           throw controllerState.error!;
        }
      }

      if (!mounted) return;
      context.go('/home');
    } catch (e, stack) {
      debugPrint('CRITICAL PROFILE ERROR: $e\n$stack');
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WeeshAppBar(
        backgroundColor: AppColors.background,
        title: 'Setup Profile',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: AppPadding.section),

            // ── Avatar picker ──
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 56,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : null,
                    child: _selectedImage == null
                        ? const Icon(
                            Icons.person,
                            size: 56,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Material(
                      color: AppColors.primary,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: _showImageSourceSheet,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: AppColors.surface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Form ──
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.horizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Juan Dela Cruz',
                    ),
                  ),
                  const SizedBox(height: AppPadding.item),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address (Optional)',
                      hintText: 'juan@email.com',
                    ),
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: _isLoading ? null : _completeSetup,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.surface,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Complete Setup'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
