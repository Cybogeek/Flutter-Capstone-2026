import 'package:flutter/material.dart';

import '../../app/app_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_sizes.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/page_background.dart';
import '../home/profile_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.pagePadding),
            child: ListView(
              children: [
                const AppPageHeader(title: 'Settings'),
                const SizedBox(height: 20),

                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('General', style: AppTextStyles.title),
                      const SizedBox(height: 12),
                      AppMenuTile(
                        icon: Icons.workspace_premium_outlined,
                        title: 'Subscription',
                        subtitle: 'Manage your current plan',
                        onTap: () {
                          Navigator.pushNamed(context, AppRouter.subscription);
                        },
                      ),
                      const SizedBox(height: 10),
                      AppMenuTile(
                        icon: Icons.volume_up_outlined,
                        title: 'Playback Settings',
                        subtitle: 'TTS speed, voice and controls',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRouter.playbackSettings,
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      AppMenuTile(
                        icon: Icons.picture_as_pdf_outlined,
                        title: 'Reader Preferences',
                        subtitle: 'Highlight, view mode and reading layout',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRouter.readerPreferences,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('App', style: AppTextStyles.title),
                      const SizedBox(height: 12),
                      AppMenuTile(
                        icon: Icons.info_outline_rounded,
                        title: 'About DOCMIND',
                        subtitle: 'Brand, features and mission',
                        onTap: () {
                          Navigator.pushNamed(context, AppRouter.about);
                        },
                      ),
                      const SizedBox(height: 10),
                      AppMenuTile(
                        icon: Icons.security_outlined,
                        title: 'Privacy & Security',
                        subtitle: 'Permissions, storage and data safety',
                        onTap: () {},
                      ),
                      const SizedBox(height: 10),
                      AppMenuTile(
                        icon: Icons.desktop_windows_outlined,
                        title: 'Platform Compatibility',
                        subtitle: 'Windows + Android support notes',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              backgroundColor: AppColors.midnight,
                              title: Text(
                                'Platform Support',
                                style: AppTextStyles.title,
                              ),
                              content: Text(
                                'DOCMIND is being tested on Android and Windows. '
                                'Some file, TTS, or PDF features may behave slightly differently across platforms.',
                                style: AppTextStyles.body,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                GlassCard(
                  child: Row(
                    children: [
                      const Icon(Icons.info, color: AppColors.subtleCyan),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'This settings page is intentionally structured early so each feature can be implemented one-by-one cleanly.',
                          style: AppTextStyles.caption,
                        ),
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
