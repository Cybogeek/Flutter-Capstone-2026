import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_sizes.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/page_background.dart';
import '../../core/widgets/primary_button.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppPageHeader(
                  title: 'Subscription',
                  onBack: Navigator.of(context).pop,
                ),
                const SizedBox(height: 18),
                Text(
                  'Powerful learning,\nstudent-friendly pricing.',
                  style: AppTextStyles.h1,
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose a plan that fits your reading, revision and AI study needs.',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 22),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 900;

                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            Expanded(
                              child: PricingCard(
                                title: 'Free',
                                price: '\$0',
                                period: '/ forever',
                                features: [
                                  'PDF reading',
                                  'AI read aloud (limited)',
                                  'Basic summaries',
                                  'Limited AI features',
                                ],
                                buttonLabel: 'Get Started',
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: PricingCard(
                                title: 'Student',
                                price: '\$1.99',
                                period: '/ month',
                                badge: 'Most Popular',
                                highlighted: true,
                                features: [
                                  'AI core features',
                                  'Smart highlights',
                                  'Summaries & Notes',
                                  'Quiz & Flashcards',
                                  'Study Mode',
                                  'Generous AI usage',
                                ],
                                buttonLabel: 'Start Now',
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: PricingCard(
                                title: 'Pro',
                                price: '\$4.99',
                                period: '/ month',
                                features: [
                                  'Higher AI limits',
                                  'Advanced features',
                                  'Multiple documents',
                                  'Priority support',
                                ],
                                buttonLabel: 'Upgrade',
                              ),
                            ),
                          ],
                        );
                      }

                      return ListView(
                        padding: EdgeInsets.zero,
                        children: const [
                          PricingCard(
                            title: 'Free',
                            price: '\$0',
                            period: '/ forever',
                            features: [
                              'PDF reading',
                              'AI read aloud (limited)',
                              'Basic summaries',
                              'Limited AI features',
                            ],
                            buttonLabel: 'Get Started',
                          ),
                          SizedBox(height: 16),
                          PricingCard(
                            title: 'Student',
                            price: '\$1.99',
                            period: '/ month',
                            badge: 'Most Popular',
                            highlighted: true,
                            features: [
                              'AI core features',
                              'Smart highlights',
                              'Summaries & Notes',
                              'Quiz & Flashcards',
                              'Study Mode',
                              'Generous AI usage',
                            ],
                            buttonLabel: 'Start Now',
                          ),
                          SizedBox(height: 16),
                          PricingCard(
                            title: 'Pro',
                            price: '\$4.99',
                            period: '/ month',
                            features: [
                              'Higher AI limits',
                              'Advanced features',
                              'Multiple documents',
                              'Priority support',
                            ],
                            buttonLabel: 'Upgrade',
                          ),
                          SizedBox(height: 8),
                        ],
                      );
                    },
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

class PricingCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final List<String> features;
  final String buttonLabel;
  final bool highlighted;
  final String? badge;

  const PricingCard({
    super.key,
    required this.title,
    required this.price,
    required this.period,
    required this.features,
    required this.buttonLabel,
    this.highlighted = false,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 320),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: highlighted
                ? AppColors.electricViolet.withValues(alpha: 0.12)
                : AppColors.midnight.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: highlighted ? AppColors.electricViolet : AppColors.border,
              width: highlighted ? 1.5 : 1,
            ),
            boxShadow: highlighted
                ? [
                    BoxShadow(
                      color: AppColors.electricViolet.withValues(alpha: 0.24),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: AppTextStyles.title),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: AppTextStyles.h1.copyWith(
                      color: highlighted ? Colors.white : AppColors.paper,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(period, style: AppTextStyles.caption),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...features.map(
                (feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.check_rounded,
                          size: 18,
                          color: AppColors.subtleCyan,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(feature, style: AppTextStyles.body)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(label: buttonLabel, onTap: () {}),
            ],
          ),
        ),
        if (badge != null)
          Positioned(
            top: -10,
            left: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.electricViolet,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                badge!,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
