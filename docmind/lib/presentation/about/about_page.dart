import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_sizes.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/page_background.dart';
import '../../core/widgets/primary_button.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'icon': Icons.graphic_eq_rounded,
        'title': 'AI Read Aloud',
        'desc':
            'Turn PDFs into audiobook-style lessons with synchronized reading.',
      },
      {
        'icon': Icons.chat_bubble_outline_rounded,
        'title': 'Ask DOCMIND',
        'desc': 'Get instant answers based on your study material.',
      },
      {
        'icon': Icons.auto_fix_high_rounded,
        'title': 'Smart Highlights',
        'desc': 'Automatically identify key concepts and create concise notes.',
      },
      {
        'icon': Icons.quiz_outlined,
        'title': 'Quiz & Flashcards',
        'desc': 'Generate practice questions and revision cards from PDFs.',
      },
      {
        'icon': Icons.layers_outlined,
        'title': 'Study Mode',
        'desc': 'Turn a chapter into a structured learning session.',
      },
      {
        'icon': Icons.picture_as_pdf_outlined,
        'title': 'Works with Your Material',
        'desc': 'Use PDFs, notes, handouts, textbooks and more.',
      },
    ];

    return Scaffold(
      body: PageBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.pagePadding),
            child: ListView(
              children: [
                const AppPageHeader(title: 'About DOCMIND'),
                const SizedBox(height: 20),

                Text(
                  'Turn Your Study PDFs\nInto Lessons.',
                  style: AppTextStyles.h1,
                ),
                const SizedBox(height: 12),
                Text(
                  'DOCMIND is an affordable AI study companion that turns your PDFs, notes and study material into an interactive learning experience—helping you listen, understand, revise and practice instead of simply reading hundreds of pages.',
                  style: AppTextStyles.body.copyWith(height: 1.7),
                ),
                const SizedBox(height: 18),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const [
                    _TagChip(label: 'For Students'),
                    _TagChip(label: 'Affordable'),
                    _TagChip(label: 'Powered by AI'),
                    _TagChip(label: 'Built for Real Learning'),
                  ],
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        label: 'Get Started Free',
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.electricViolet,
                          ),
                          foregroundColor: AppColors.paper,
                          minimumSize: const Size.fromHeight(56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.play_circle_outline_rounded),
                        label: const Text('Watch Video'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 26),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 760;
                    if (isWide) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: features.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.2,
                            ),
                        itemBuilder: (_, index) {
                          final feature = features[index];
                          return _FeatureCard(
                            icon: feature['icon'] as IconData,
                            title: feature['title'] as String,
                            desc: feature['desc'] as String,
                          );
                        },
                      );
                    }

                    return Column(
                      children: features
                          .map(
                            (feature) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _FeatureCard(
                                icon: feature['icon'] as IconData,
                                title: feature['title'] as String,
                                desc: feature['desc'] as String,
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.subtleCyan, size: 28),
          const SizedBox(height: 12),
          Text(title, style: AppTextStyles.title),
          const SizedBox(height: 8),
          Text(desc, style: AppTextStyles.caption.copyWith(height: 1.6)),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.midnight,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(label, style: AppTextStyles.caption),
    );
  }
}
