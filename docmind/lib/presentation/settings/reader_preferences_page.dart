import 'package:flutter/material.dart';

import '../../app/theme/app_sizes.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/page_background.dart';

class ReaderPreferencesPage extends StatelessWidget {
  const ReaderPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.pagePadding),
            child: ListView(
              children: [
                const AppPageHeader(title: 'Reader Preferences'),
                const SizedBox(height: 20),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Reader Preferences', style: AppTextStyles.title),
                      const SizedBox(height: 10),
                      Text(
                        'Future controls: theme, page fit, highlight color, reading mode and layout.',
                        style: AppTextStyles.body,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
