import 'package:flutter/material.dart';

import '../../../app/theme/app_sizes.dart';
import '../../../core/widgets/shimmer_box.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ShimmerBox(height: 18, width: 130),
          SizedBox(height: 8),
          ShimmerBox(height: 28, width: 180),
          SizedBox(height: 24),
          ShimmerBox(height: 56, width: double.infinity),
          SizedBox(height: 28),
          ShimmerBox(height: 20, width: 120),
          SizedBox(height: 16),
          ShimmerBox(height: 76, width: double.infinity),
          SizedBox(height: 12),
          ShimmerBox(height: 76, width: double.infinity),
          SizedBox(height: 12),
          ShimmerBox(height: 76, width: double.infinity),
        ],
      ),
    );
  }
}
