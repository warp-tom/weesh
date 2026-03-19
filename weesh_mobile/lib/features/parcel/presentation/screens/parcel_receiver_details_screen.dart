import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/core/ui/weesh_app_bar.dart';
import 'package:gap/gap.dart';

class ParcelReceiverDetailsScreen extends StatefulWidget {
  const ParcelReceiverDetailsScreen({super.key});

  @override
  State<ParcelReceiverDetailsScreen> createState() => _ParcelReceiverDetailsScreenState();
}

class _ParcelReceiverDetailsScreenState extends State<ParcelReceiverDetailsScreen> {
  bool _isReceiver = true;
  String _selectedSize = 'Small Box';

  // Controllers for demo
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WeeshAppBar(
        title: 'Parcel Details',
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppPadding.section),
                children: [
                  // Toggle Switch
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoSlidingSegmentedControl<bool>(
                      backgroundColor: AppColors.neutral100,
                      thumbColor: AppColors.surface,
                      groupValue: _isReceiver,
                      onValueChanged: (value) {
                        if (value != null && value != _isReceiver) {
                          HapticFeedback.lightImpact(); // Sensory layer
                          setState(() => _isReceiver = value);
                        }
                      },
                      children: {
                        true: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Receiver',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: _isReceiver ? FontWeight.w800 : FontWeight.w600,
                              color: _isReceiver ? AppColors.deepCharcoal : AppColors.neutral500,
                            ),
                          ),
                        ),
                        false: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Sender',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: !_isReceiver ? FontWeight.w800 : FontWeight.w600,
                              color: !_isReceiver ? AppColors.deepCharcoal : AppColors.neutral500,
                            ),
                          ),
                        ),
                      },
                    ),
                  ),
                  const Gap(24),
                  // Inputs
                  Text('Contact Info', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const Gap(12),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.surface,
                      hintText: 'Full Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.neutral200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.neutral200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const Gap(12),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.surface,
                      hintText: 'Mobile Number',
                      prefixText: '+63 ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.neutral200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.neutral200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const Gap(24),
                  // Package Size
                  Text('Package Size', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const Gap(12),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildSizeCard('Envelope', 'Docs & keys', Iconsax.document, 'Envelope'),
                        const Gap(12),
                        _buildSizeCard('Small Box', 'Shoebox size', Iconsax.box, 'Small Box'),
                        const Gap(12),
                        _buildSizeCard('Large Item', 'Appliances', Iconsax.box_add, 'Large Item'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppPadding.section),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    context.push('/parcel_service_type'); // Routes to Routing & Fee
                  },
                  child: const Text('Next: Routing & Fee'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeCard(String title, String subtitle, IconData icon, String value) {
    final isSelected = _selectedSize == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedSize = value),
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.sageGreen.withValues(alpha: 0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.neutral200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.neutral500),
            const Spacer(),
            Text(title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: AppColors.deepCharcoal)),
            Text(subtitle, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.warmGrey)),
          ],
        ),
      ),
    );
  }
}
