// lib/presentation/home/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_sizes.dart';
import '../../app/theme/app_text_styles.dart';
import '../../business/providers/auth_provider.dart';
import '../../business/providers/library_provider.dart';
import '../../core/widgets/app_search_bar.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/page_background.dart';
import '../../core/widgets/section_header.dart';
import '../../data/models/pdf_item_model.dart';
import 'widgets/recent_pdf_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final library = ref.watch(libraryProvider);

    return Scaffold(
      body: PageBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.pagePadding),
            child: library.when(
              loading: () => _shimmer(),
              error: (e, s) => _error(e.toString()),
              data: (items) {
                final recent = items.isEmpty
                    ? []
                    : items.sublist(0, items.length < 5 ? items.length : 5);
                final mostRecent = items.isEmpty ? null : items.first;
                final continuePDF = mostRecent;

                return ListView(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Good Morning,\n',
                                  style: AppTextStyles.body,
                                ),
                                TextSpan(
                                  text: user?.name ?? 'Learner',
                                  style: AppTextStyles.h1,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.midnight,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: AppColors.paper,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const AppSearchBar(),
                    const SizedBox(height: 20),
                    _heroCard(continuePDF, context, ref),
                    const SizedBox(height: 20),
                    _quickActions(context, ref),
                    if (continuePDF != null) ...[
                      const SizedBox(height: 24),
                      const SectionHeader(
                        title: 'Continue Reading',
                        actionText: 'View All',
                      ),
                      const SizedBox(height: 12),
                      _continueCard(
                        item: continuePDF,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRouter.reader,
                          arguments: continuePDF,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    const SectionHeader(title: 'Recent Documents'),
                    const SizedBox(height: 12),
                    if (recent.isEmpty)
                      _emptyDocuments()
                    else
                      GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 8 / 3,
                            ),
                        itemCount: recent.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = recent[index];
                          return RecentPdfCard(
                            title: item.name,
                            subtitle: 'Page ${item.lastPage}',
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRouter.reader,
                              arguments: item,
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 40),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _shimmer() => Container(); // Replace later

  Widget _error(String error) => Center(child: Text(error));

  Widget _heroCard(PdfItemModel? pdf, BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF101C44), Color(0xFF182A63), AppColors.deepInk],
        ),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.electricViolet.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('DOCMIND: AI Study Companion', style: AppTextStyles.h1),
          const SizedBox(height: 8),
          Text(
            'Turn dense texts into clear audio lessons using AI understanding.',
            style: AppTextStyles.body.copyWith(height: 1.6),
          ),
          const SizedBox(height: 16),
          if (pdf == null)
            _aiActionButton('Upload My First PDF')
          else
            _aiActionButton('Continue Studying'),
        ],
      ),
    );
  }

  Widget _aiActionButton(String label) {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.mutedPurple, AppColors.electricViolet],
        ),
        borderRadius: BorderRadiusDirectional.all(Radius.circular(16)),
      ),
      child: Center(
        child: Text(
          label,
          style: AppTextStyles.title.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _quickActions(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: _QuickAction(
            icon: Icons.auto_awesome_rounded,
            label: 'Ask DOCMIND',
            onTap: () => Navigator.pushNamed(context, AppRouter.askDoc),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickAction(
            icon: Icons.play_circle_filled_rounded,
            label: 'Listen Now',
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _continueCard({
    required PdfItemModel item,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.electricViolet.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: AppColors.subtleCyan,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: AppTextStyles.title),
                const SizedBox(height: 2),
                Text('Page ${item.lastPage}', style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyDocuments() {
    return GlassCard(
      child: Text(
        'No recent documents. Add one from Library to get started.',
        style: AppTextStyles.body,
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.midnight,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.subtleCyan),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.body,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
