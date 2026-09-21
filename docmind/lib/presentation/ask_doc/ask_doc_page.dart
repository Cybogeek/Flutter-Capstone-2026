import 'package:docmind/business/providers/user_plan_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_sizes.dart';
import '../../app/theme/app_text_styles.dart';
import '../../business/providers/ai_chat_provider.dart';
import '../../business/providers/app_providers.dart';
import '../../business/providers/usage_limit_provider.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/page_background.dart';
import '../../data/models/pdf_item_model.dart';

class AskDocPage extends ConsumerStatefulWidget {
  final PdfItemModel? pdfItem;

  const AskDocPage({super.key, this.pdfItem});

  @override
  ConsumerState<AskDocPage> createState() => _AskDocPageState();
}

class _AskDocPageState extends ConsumerState<AskDocPage> {
  final TextEditingController _textController = TextEditingController();
  bool _isAsking = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final pdf = widget.pdfItem;
      if (pdf != null) {
        ref.read(aiChatProvider.notifier).loadChats(pdf.id);
      } else {
        ref.read(aiChatProvider.notifier).state = const AsyncValue.data([]);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _askGemini() async {
    final pdf = widget.pdfItem;
    if (pdf == null) return;

    final question = _textController.text.trim();
    if (question.isEmpty) return;

    final usageInfoAsync = ref.read(usageLimitProvider);

    if (!usageInfoAsync.hasValue) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait, loading user plan...')),
      );
      return;
    }

    final usageInfo = usageInfoAsync.value!;
    final user = usageInfo.user;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found. Please log in again.')),
      );
      return;
    }

    if (usageInfo.hasLimitReached) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Daily AI limit reached (${usageInfo.usageCount}/${usageInfo.dailyLimit}).',
          ),
        ),
      );
      return;
    }

    setState(() => _isAsking = true);

    try {
      final aiService = ref.read(aiDocumentServiceProvider);
      final result = await aiService.analyzeDocument(pdf.path);

      final answer = result.isSuccess
          ? _buildAnswer(result)
          : (result.errorMessage ?? 'Unable to analyze document.');

      await ref
          .read(aiChatProvider.notifier)
          .askQuestion(pdfId: pdf.id, question: question, answer: answer);

      await ref.read(appauthRepositoryProvider).incrementUsage(user.id);

      ref.invalidate(userPlanProvider);
      ref.invalidate(usageLimitProvider);

      _textController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something went wrong: $e')));
    } finally {
      if (mounted) {
        setState(() => _isAsking = false);
      }
    }
  }

  String _buildAnswer(dynamic result) {
    final summary = result.summary ?? 'No summary available.';
    final keyPoints =
        (result.keyPoints as List?)?.take(3).map((e) => '• $e').join('\n') ??
        '• No key points available.';
    final readable = result.readableText ?? 'No readable answer generated.';

    return '''
Summary:
$summary

Key Points:
$keyPoints

Response:
$readable
''';
  }

  @override
  Widget build(BuildContext context) {
    final pdf = widget.pdfItem;
    final usageInfoAsync = ref.watch(usageLimitProvider);
    final chatState = ref.watch(aiChatProvider);

    return Scaffold(
      body: PageBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.pagePadding),
            child: Column(
              children: [
                const AppPageHeader(title: 'Ask DOCMIND'),
                const SizedBox(height: 8),
                Text(
                  pdf == null
                      ? 'Open a PDF from Reader to ask document-specific questions.'
                      : 'Ask anything about this document.',
                  style: AppTextStyles.caption,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                usageInfoAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (usageInfo) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: usageInfo.hasLimitReached
                            ? AppColors.error.withValues(alpha: 0.15)
                            : AppColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: usageInfo.hasLimitReached
                              ? AppColors.error
                              : AppColors.success,
                        ),
                      ),
                      child: Text(
                        'Usage: ${usageInfo.usageCount}/${usageInfo.dailyLimit}',
                        style: AppTextStyles.caption.copyWith(
                          color: usageInfo.hasLimitReached
                              ? AppColors.error
                              : AppColors.success,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: pdf == null
                      ? Center(
                          child: Text(
                            'No document selected.',
                            style: AppTextStyles.body,
                          ),
                        )
                      : chatState.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Center(
                            child: Text(
                              'Failed to load chat history',
                              style: AppTextStyles.body,
                            ),
                          ),
                          data: (chats) {
                            if (chats.isEmpty) {
                              return Center(
                                child: Text(
                                  'Ask your first question about this PDF.',
                                  style: AppTextStyles.body,
                                ),
                              );
                            }

                            return ListView.builder(
                              reverse: true,
                              itemCount: chats.length,
                              itemBuilder: (context, index) {
                                final msg = chats[index];
                                return _ChatBubble(
                                  question: msg.question,
                                  answer: msg.answer,
                                );
                              },
                            );
                          },
                        ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: TextField(
                          controller: _textController,
                          enabled: pdf != null && !_isAsking,
                          decoration: const InputDecoration(
                            hintText: 'Ask about this document...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onSubmitted: (_) => _askGemini(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: pdf == null
                            ? null
                            : const LinearGradient(
                                colors: [
                                  AppColors.mutedPurple,
                                  AppColors.electricViolet,
                                ],
                              ),
                        color: pdf == null ? AppColors.slate : null,
                      ),
                      child: IconButton(
                        onPressed: (pdf == null || _isAsking)
                            ? null
                            : _askGemini,
                        icon: _isAsking
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String question;
  final String answer;

  const _ChatBubble({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.electricViolet,
            borderRadius: BorderRadius.circular(16),
          ),
          constraints: const BoxConstraints(maxWidth: 320),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question,
                style: AppTextStyles.body.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                answer,
                style: AppTextStyles.caption.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
