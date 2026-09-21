import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_sizes.dart';
import '../../app/theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final IconData? icon;
  final double height;
  final bool expanded;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.icon,
    this.height = AppSizes.buttonHeight,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AppColors.mutedPurple, AppColors.electricViolet],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.electricViolet.withValues(alpha: 0.35),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: AppTextStyles.title.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );

    return AbsorbPointer(
      absorbing: isLoading || onTap == null,
      child: Opacity(
        opacity: onTap == null ? 0.55 : 1,
        child: GestureDetector(
          onTap: onTap,
          child: expanded
              ? SizedBox(width: double.infinity, child: buttonChild)
              : buttonChild,
        ),
      ),
    );
  }
}
