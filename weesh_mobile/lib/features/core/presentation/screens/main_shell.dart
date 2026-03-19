import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:flutter/services.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    HapticFeedback.lightImpact();
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.secondary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: const [
          NavigationDestination(
            icon: Icon(Iconsax.home_2),
            selectedIcon: Icon(Iconsax.home_2_copy),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.activity),
            selectedIcon: Icon(Iconsax.activity_copy),
            label: 'Activity',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.wallet_2),
            selectedIcon: Icon(Iconsax.wallet_2_copy),
            label: 'Wallet',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.profile_circle),
            selectedIcon: Icon(Iconsax.profile_circle_copy),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
