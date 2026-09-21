import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/theme/app_colors.dart';

class ShimmerBox extends StatelessWidget {
  final double height;
  final double width;
  final double radius;

  const ShimmerBox({
    super.key,
    required this.height,
    required this.width,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.midnight,
      highlightColor: AppColors.slate,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.midnight,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
