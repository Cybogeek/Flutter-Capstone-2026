// lib/presentation/reader/reader_page.dart

import 'dart:io' show Platform;

import 'package:docmind/data/models/ai_reader_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfx/pdfx.dart';

import '../../app/app_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_sizes.dart';
import '../../app/theme/app_text_styles.dart';
import '../../business/providers/ai_reader_provider.dart';
import '../../business/providers/library_provider.dart';
import '../../business/providers/nav_provider.dart';
import '../../core/widgets/adaptive_pdf_view.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/page_background.dart';
import '../../data/models/pdf_item_model.dart';

class ReaderPage extends ConsumerStatefulWidget {
  final PdfItemModel? pdfItem;

  const ReaderPage({super.key, this.pdfItem});

  @override
  ConsumerState<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends ConsumerState<ReaderPage> {
  PdfControllerPinch? _pinchController;
  PdfController? _standardController;
  bool _isAnalyzing = false;

  int _currentPage = 1;
  int _totalPages = 1;

  PdfItemModel? get item => widget.pdfItem;

  bool get _useStandardView {
    if (kIsWeb) return true;
    return Platform.isWindows;
  }

  @override
  void initState() {
    super.initState();
    if (item != null) {
      _setupPdf();
    }
  }

  Future<void> _setupPdf() async {
    final pdf = widget.pdfItem;
    if (pdf == null) return;

    final document = PdfDocument.openFile(pdf.path);

    if (_useStandardView) {
      _standardController = PdfController(
        document: document,
        initialPage: pdf.lastPage,
      );
    } else {
      _pinchController = PdfControllerPinch(
        document: document,
        initialPage: pdf.lastPage,
      );
    }

    if (mounted) {
      setState(() {});
    }

    // Trigger AI preparation after controller is ready
    ref
        .read(libraryProvider.notifier)
        .updateLastPage(pdfId: pdf.id, page: pdf.lastPage);
  }

  @override
  void dispose() {
    _pinchController?.dispose();
    _standardController?.dispose();
    super.dispose();
  }

  void _startAiAnalysis() async {
    final pdf = item;
    if (pdf == null) return;

    final aiReader = ref.read(aiReaderProvider.notifier);
    await aiReader.prepareDocumentForReading(pdf.path);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('AI document analysis complete')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final aiReaderState = ref.watch(aiReaderProvider);
    final pdf = item;

    if (pdf == null) {
      return Scaffold(
        body: PageBackground(
          child: Center(
            child: Text('No PDF selected', style: AppTextStyles.body),
          ),
        ),
      );
    }

    return Scaffold(
      body: PageBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.pagePadding),
            child: Column(
              children: [
                // Top Bar: Back, Title, AI Action
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            pdf.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.title,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$_currentPage / $_totalPages',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRouter.askDoc,
                          arguments: pdf,
                        );
                      },
                      icon: const Icon(Icons.auto_awesome_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // AI Processing Status
                if (aiReaderState.errorMessage != null)
                  _errorMessage(aiReaderState.errorMessage!)
                else if (aiReaderState.isPreparing || _isAnalyzing)
                  _loadingCard('AI is analyzing your document...')
                else if (aiReaderState.readableText != null)
                  _successCard()
                else
                  _prepareButton(() => _startAiAnalysis()),

                // PDF Viewer Section
                const SizedBox(height: 12),
                Expanded(
                  child: GlassCard(
                    padding: const EdgeInsets.all(8),
                    child: AdaptivePdfView(
                      controller: _standardController,
                      pinchController: _pinchController,
                      onPageChanged: (page) async {
                        _currentPage = page;
                        if (mounted) setState(() {});
                        await ref
                            .read(libraryProvider.notifier)
                            .updateLastPage(pdfId: pdf.id, page: page);
                      },
                      onDocumentLoaded: (document) {
                        _totalPages = document.pagesCount;
                        if (mounted) setState(() {});
                      },
                    ),
                  ),
                ),

                // Bottom Player Controls
                const SizedBox(height: 18),
                GlassCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: _buildPlayerControls(context, aiReaderState),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerControls(BuildContext context, AiReaderModel state) {
    final aiNotifier = ref.read(aiReaderProvider.notifier);
    final readerProvider = ref.read(aiReaderProvider);

    if (state.isSpeaking) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(), // placeholder
          GestureDetector(
            onTap: () async {
              await aiNotifier.stopSpeaking();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Playback stopped')),
                );
              }
            },
            child: Container(
              width: 54,
              height: 54,
              decoration: const BoxDecoration(
                color: AppColors.subtleCyan,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.stop_rounded, color: Colors.white),
            ),
          ),
          Row(
            children: [
              Text(
                '${state.ttsRate.toStringAsFixed(2)}x',
                style: AppTextStyles.caption,
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 60,
                child: Slider(
                  value: state.ttsRate,
                  min: 0.2,
                  max: 0.8,
                  onChanged: (value) => aiNotifier.updateTtsRate(value),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        // Speed slider
        Row(
          children: [
            Expanded(
              child: Slider(
                value: readerProvider.ttsRate,
                min: 0.2,
                max: 0.8,
                onChanged: (value) => aiNotifier.updateTtsRate(value),
              ),
            ),
            Text(
              '${readerProvider.ttsRate.toStringAsFixed(2)}x',
              style: AppTextStyles.caption,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (state.readableText != null)
              _ReaderControlButton(
                icon: Icons.home_rounded,
                onTap: () {
                  ref.read(navProvider.notifier).setNavIndex(0);
                  Navigator.pop(context);
                },
              ),
            _ReaderControlButton(
              icon: state.readableText == null
                  ? Icons.auto_awesome_rounded
                  : Icons.play_arrow_rounded,
              isPrimary: true,
              onTap: () {
                if (state.readableText != null) {
                  aiNotifier.speakReadableText();
                } else {
                  _startAiAnalysis();
                }
              },
            ),
            _ReaderControlButton(
              icon: Icons.auto_fix_high_rounded,
              onTap: () {
                if (state.summary != null) {
                  aiNotifier.speakSummary();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Generate AI content first to play summary.',
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _errorMessage(String error) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              error,
              style: AppTextStyles.caption,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadingCard(String message) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: AppTextStyles.caption)),
        ],
      ),
    );
  }

  Widget _successCard() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColors.subtleCyan,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'AI-optimized reading is ready.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.subtleCyan,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _prepareButton(VoidCallback onTap) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.mutedPurple, AppColors.electricViolet],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Prepare AI-Optimized Reading',
              style: AppTextStyles.body,
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.lavender),
        ],
      ),
    );
  }
}

// Reusable Button
class _ReaderControlButton extends StatelessWidget {
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ReaderControlButton({
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isPrimary ? 54 : 46,
        height: isPrimary ? 54 : 46,
        decoration: BoxDecoration(
          color: isPrimary ? null : AppColors.midnight,
          gradient: isPrimary
              ? const LinearGradient(
                  colors: [AppColors.mutedPurple, AppColors.electricViolet],
                )
              : null,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
