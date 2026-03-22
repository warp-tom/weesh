import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weesh_mobile/core/theme/constants.dart';
import 'package:weesh_mobile/core/widgets/weesh_map.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:gap/gap.dart';

class ParcelServiceTypeScreen extends StatefulWidget {
  const ParcelServiceTypeScreen({super.key});

  @override
  State<ParcelServiceTypeScreen> createState() =>
      _ParcelServiceTypeScreenState();
}

class _ParcelServiceTypeScreenState extends State<ParcelServiceTypeScreen> {
  int _selectedVehicle = 0;
  int _selectedSize = 0;
  bool _hasInsurance = false;

  static const _vehicles = [
    {'icon': Icons.two_wheeler, 'name': 'Motor', 'time': '5 mins', 'fee': 85.0},
    {
      'icon': Icons.electric_rickshaw,
      'name': 'Tricycle',
      'time': '12 mins',
      'fee': 120.0,
    },
    {
      'icon': Icons.local_shipping,
      'name': 'L300 Van',
      'time': '30 mins',
      'fee': 250.0,
    },
  ];

  static const _sizes = [
    {'label': 'Small', 'desc': 'Up to 3 kg', 'surcharge': 0.0},
    {'label': 'Medium', 'desc': 'Up to 10 kg', 'surcharge': 25.0},
    {'label': 'Large', 'desc': 'Up to 25 kg', 'surcharge': 60.0},
  ];

  double get _totalFee {
    final baseFee = _vehicles[_selectedVehicle]['fee'] as double;
    final sizeSurcharge = _sizes[_selectedSize]['surcharge'] as double;
    final insurance = _hasInsurance ? 15.0 : 0.0;
    return baseFee + sizeSurcharge + insurance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Map Background
          const Positioned.fill(
            child: WeeshMap(myLocationEnabled: false),
          ),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: CircleAvatar(
              backgroundColor: AppColors.surface,
              child: BackButton(
                color: AppColors.textBody,
                onPressed: () => context.pop(),
              ),
            ),
          ),

          // Bottom Sheet with Vehicle, Size, Insurance & Fee
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(AppPadding.section),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ─── Vehicle Selection ───
                      Text(
                        'Select Vehicle',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepCharcoal,
                        ),
                      ),
                      const Gap(12),
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _vehicles.length,
                          separatorBuilder: (_, __) => const Gap(12),
                          itemBuilder: (context, index) {
                            final v = _vehicles[index];
                            return Semantics(
                              label: 'Vehicle ${v['name']}, ${v['time']}, fee ₱${v['fee']}',
                              button: true,
                              selected: _selectedVehicle == index,
                              child: _VehicleCard(
                                icon: v['icon'] as IconData,
                                name: v['name'] as String,
                                time: v['time'] as String,
                                isSelected: _selectedVehicle == index,
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setState(() => _selectedVehicle = index);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const Gap(20),

                      // ─── Package Size ───
                      Text(
                        'Package Size',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepCharcoal,
                        ),
                      ),
                      const Gap(12),
                      Row(
                        children: List.generate(_sizes.length, (index) {
                          final s = _sizes[index];
                          final isSelected = _selectedSize == index;
                          return Expanded(
                            child: Semantics(
                              label: 'Size ${s['label']}, capacity ${s['desc']}, surcharge ₱${s['surcharge']}',
                              button: true,
                              selected: isSelected,
                              child: GestureDetector(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setState(() => _selectedSize = index);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                    right: index < _sizes.length - 1 ? 8 : 0,
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.background,
                                    borderRadius: BorderRadius.circular(12),
                                    border: isSelected
                                        ? null
                                        : Border.all(
                                            color: AppColors.neutral200,
                                          ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        s['label'] as String,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: isSelected
                                              ? Colors.white
                                              : AppColors.deepCharcoal,
                                        ),
                                      ),
                                      const Gap(2),
                                      Text(
                                        s['desc'] as String,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          color: isSelected
                                              ? Colors.white70
                                              : AppColors.neutral500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const Gap(16),

                      // ─── Insurance Toggle ───
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.neutral200),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Iconsax.shield_tick,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const Gap(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Package Insurance',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: AppColors.deepCharcoal,
                                    ),
                                  ),
                                  Text(
                                    '+₱15.00 · Covers up to ₱5,000',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: AppColors.warmGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch.adaptive(
                              value: _hasInsurance,
                              onChanged: (v) =>
                                  setState(() => _hasInsurance = v),
                              activeThumbColor: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 32,
                        color: AppColors.neutral200,
                      ),

                      // ─── Routing & Fee Summary ───
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Distance',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.neutral500,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                '4.2 km',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.deepCharcoal,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Estimated Time',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.neutral500,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                _vehicles[_selectedVehicle]['time'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.deepCharcoal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(
                        height: 32,
                        color: AppColors.neutral200,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivery Fee',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.deepCharcoal,
                            ),
                          ),
                          Text(
                            '₱ ${_totalFee.toStringAsFixed(2)}',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const Gap(20),
                      FilledButton(
                        onPressed: () => context.push(
                          '/parcel_tracking',
                          extra: {
                            'vehicle': _vehicles[_selectedVehicle],
                            'size': _sizes[_selectedSize],
                            'insurance': _hasInsurance,
                            'totalFee': _totalFee,
                          },
                        ),
                        style: FilledButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Confirm Delivery',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({
    required this.icon,
    required this.name,
    required this.time,
    required this.onTap,
    this.isSelected = false,
  });

  final IconData icon;
  final String name;
  final String time;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.deepCharcoal : AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border:
              isSelected ? null : Border.all(color: AppColors.neutral200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.deepCharcoal,
            ),
            const Gap(8),
            Text(
              name,
              style: GoogleFonts.plusJakartaSans(
                color:
                    isSelected ? Colors.white : AppColors.deepCharcoal,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            Text(
              time,
              style: GoogleFonts.plusJakartaSans(
                color: isSelected
                    ? AppColors.neutral200
                    : AppColors.neutral500,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
