import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_sizes.dart';
import '../../app/theme/app_text_styles.dart';
import '../../business/providers/auth_provider.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/page_background.dart';
import '../../core/widgets/primary_button.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      body: PageBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.pagePadding),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        constraints.maxHeight - (AppSizes.pagePadding * 2),
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Profile', style: AppTextStyles.h1),
                        const SizedBox(height: 24),

                        GlassCard(
                          child: Row(
                            children: [
                              Container(
                                width: 58,
                                height: 58,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.mutedPurple,
                                      AppColors.subtleCyan,
                                    ],
                                  ),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user?.name ?? 'Learner',
                                      style: AppTextStyles.title,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      user?.email ?? 'No email',
                                      style: AppTextStyles.caption,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        GlassCard(
                          child: Column(
                            children: [
                              AppMenuTile(
                                icon: Icons.workspace_premium_outlined,
                                title: 'Subscription',
                                subtitle: 'View plans and upgrade',
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRouter.subscription,
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              AppMenuTile(
                                icon: Icons.settings_outlined,
                                title: 'Settings',
                                subtitle:
                                    'Preferences, theme, playback and more',
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRouter.settings,
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              AppMenuTile(
                                icon: Icons.bookmark_outline_rounded,
                                title: 'Bookmarks',
                                subtitle: 'Your saved highlights and sections',
                                onTap: () {},
                              ),
                              const SizedBox(height: 10),
                              AppMenuTile(
                                icon: Icons.help_outline_rounded,
                                title: 'Help & Support',
                                subtitle: 'FAQs and contact support',
                                onTap: () {
                                  Navigator.pushNamed(context, AppRouter.about);
                                },
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),
                        const SizedBox(height: 24),

                        PrimaryButton(
                          label: 'Sign Out',
                          icon: Icons.logout_rounded,
                          onTap: () async {
                            await ref.read(authProvider.notifier).signOut();
                            if (context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRouter.signIn,
                                (_) => false,
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class AppMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const AppMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.midnight.withOpacity(0.75),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: AppColors.electricViolet.withOpacity(0.16),
        highlightColor: AppColors.subtleCyan.withOpacity(0.08),
        hoverColor: AppColors.subtleCyan.withOpacity(0.06),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.electricViolet.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.subtleCyan),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.paper,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(subtitle!, style: AppTextStyles.caption),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.lavender,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
