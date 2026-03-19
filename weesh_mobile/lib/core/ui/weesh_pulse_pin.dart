import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:weesh_mobile/core/theme/constants.dart';

class WeeshPulsePin extends StatelessWidget {
  final Color color;
  final IconData icon;

  const WeeshPulsePin({
    super.key,
    this.color = AppColors.terracotta,
    this.icon = Icons.location_on_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return MirrorAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 15.0),
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOutSine,
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 48 + value,
              height: 48 + value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.2),
              ),
            ),
            Container(
              width: 32 + (value * 0.5),
              height: 32 + (value * 0.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.4),
              ),
            ),
            child!,
          ],
        );
      },
      child: Center(
        child: Icon(
          icon,
          color: color,
          size: 36,
        ),
      ),
    );
  }
}
