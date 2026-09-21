import 'package:flutter/material.dart';

import '../../app/theme/app_text_styles.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: AppTextStyles.h1, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(subtitle, style: AppTextStyles.body, textAlign: TextAlign.center),
      ],
    );
  }
}
