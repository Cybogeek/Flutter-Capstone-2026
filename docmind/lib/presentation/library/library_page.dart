import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_router.dart';
import '../../app/theme/app_sizes.dart';
import '../../app/theme/app_text_styles.dart';
import '../../business/providers/library_provider.dart';
import '../../core/widgets/page_background.dart';
import '../../core/widgets/section_header.dart';
import '../../data/models/pdf_item_model.dart';
import 'widgets/library_pdf_card.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  void _openReader(BuildContext context, PdfItemModel item) {
    Navigator.pushNamed(context, AppRouter.reader, arguments: item);
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    PdfItemModel item,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove PDF'),
        content: Text('Remove "${item.name}" from your app library?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(libraryProvider.notifier).removePdf(item.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item.name} removed from library')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryState = ref.watch(libraryProvider);

    return Scaffold(
      body: PageBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Library', style: AppTextStyles.h1),
                const SizedBox(height: 20),
                SectionHeader(
                  title: 'Your PDFs',
                  actionText: 'Add PDF',
                  onActionTap: () async {
                    final added = await ref
                        .read(libraryProvider.notifier)
                        .addPdf();
                    if (added != null && context.mounted) {
                      _openReader(context, added);
                    }
                  },
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: libraryState.when(
                    data: (items) {
                      if (items.isEmpty) {
                        return Center(
                          child: Text(
                            'No PDFs added yet.\nUse "Add PDF" to import your first document.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body,
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return LibraryPdfCard(
                            item: item,
                            onTap: () => _openReader(context, item),
                            onDelete: () => _confirmDelete(context, ref, item),
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(
                      child: Text(
                        'Failed to load library',
                        style: AppTextStyles.body,
                      ),
                    ),
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
