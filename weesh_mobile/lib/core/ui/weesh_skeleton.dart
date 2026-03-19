import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weesh_mobile/core/theme/constants.dart';

/// Shimmer skeleton loader system for all loading states.
///
/// Usage:
/// ```dart
/// if (isLoading) WeeshSkeleton.card() else WeeshCard(...)
/// ```
class WeeshSkeleton extends StatelessWidget {
  const WeeshSkeleton._({super.key, required this.child});

  factory WeeshSkeleton.card({Key? key}) => WeeshSkeleton._(
        key: key,
        child: const _SkeletonBox(
          width: double.infinity,
          height: 120,
          radius: AppRadius.card,
        ),
      );

  factory WeeshSkeleton.listTile({Key? key}) => WeeshSkeleton._(
        key: key,
        child: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.horizontal,
            vertical: 8,
          ),
          child: Row(
            children: [
              _SkeletonBox(width: 48, height: 48, radius: 24),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonBox(width: double.infinity, height: 14),
                    SizedBox(height: 8),
                    _SkeletonBox(width: 120, height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  factory WeeshSkeleton.grid({Key? key, int count = 3}) => WeeshSkeleton._(
        key: key,
        child: Row(
          children: List.generate(
            count,
            (i) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: i == 0 ? AppPadding.horizontal : 6,
                  right: i == count - 1 ? AppPadding.horizontal : 6,
                ),
                child: const _SkeletonBox(height: 88, radius: AppRadius.card),
              ),
            ),
          ),
        ),
      );

  factory WeeshSkeleton.text({Key? key, double width = double.infinity, double height = 14}) =>
      WeeshSkeleton._(
        key: key,
        child: _SkeletonBox(width: width, height: height, radius: 6),
      );

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child.animate(onPlay: (controller) => controller.repeat()).shimmer(
      duration: 1200.ms,
      color: AppColors.neutral100.withValues(alpha: 0.5),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.height,
    this.width = double.infinity,
    this.radius = 8,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.neutral200,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
