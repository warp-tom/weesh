import 'package:flutter/material.dart';
import 'package:weesh_mobile/core/theme/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // ignore: weesh_no_generic_appbar
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: const Center(
        child: Text('Profile Screen (Screen 25) Placeholder'),
      ),
    );
  }
}
