import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_sizes.dart';
import '../../app/theme/app_text_styles.dart';
import '../../business/providers/reader_provider.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/page_background.dart';

class PlaybackSettingsPage extends ConsumerWidget {
  const PlaybackSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readerState = ref.watch(readerProvider);

    return Scaffold(
      body: PageBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.pagePadding),
            child: ListView(
              children: [
                const AppPageHeader(title: 'Playback Settings'),
                const SizedBox(height: 20),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Speech Rate', style: AppTextStyles.title),
                      const SizedBox(height: 14),
                      Slider(
                        value: readerState.ttsRate,
                        min: 0.2,
                        max: 0.8,
                        onChanged: (value) {
                          ref.read(readerProvider.notifier).updateRate(value);
                        },
                      ),
                      Text(
                        'Current rate: ${readerState.ttsRate.toStringAsFixed(2)}x',
                        style: AppTextStyles.caption,
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
