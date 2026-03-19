import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weesh_mobile/core/theme/constants.dart';

import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:weesh_mobile/core/ui/weesh_card.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final List<Map<String, dynamic>> _contacts = [
    {'name': 'Mom', 'phone': '+63 917 123 4567', 'enabled': true},
    {'name': 'Dad', 'phone': '+63 918 987 6543', 'enabled': true},
    {'name': 'Kuya', 'phone': '+63 919 555 1234', 'enabled': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WeeshAppBar(
        title: 'Emergency Contacts',
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppPadding.section),
              child: Text(
                'These contacts will receive your live location when you use the SOS feature during a ride.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.neutral500,
                    ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppPadding.section),
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  final contact = _contacts[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: WeeshCard(
                      borderRadius: BorderRadius.circular(12),
                      borderColor: AppColors.neutral200,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.1),
                        child: Text(
                          contact['name']
                              .toString()
                              .substring(0, 1)
                              .toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        contact['name'] as String,
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: AppColors.deepCharcoal),
                      ),
                      subtitle: Text(contact['phone'] as String),
                      trailing: Switch(
                        value: contact['enabled'] as bool,
                        onChanged: (value) {
                          setState(() {
                            _contacts[index]['enabled'] = value;
                          });
                        },
                        activeThumbColor: AppColors.primary,
                      ),
                    ),
                  ),
                  );
                },
              ),
            ),
            const SizedBox(height: 80), // spacer for fab
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Iconsax.add, color: Colors.white),
        label: const Text('Add Contact', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
