import 'package:docmind/app/app_router.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_text_styles.dart';

class AppPageHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;

  const AppPageHeader({super.key, required this.title, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed:
              onBack ??
              () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacementNamed(context, AppRouter.shell);
                }
              },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        Expanded(child: Text(title, style: AppTextStyles.h2)),
      ],
    );
  }
}
