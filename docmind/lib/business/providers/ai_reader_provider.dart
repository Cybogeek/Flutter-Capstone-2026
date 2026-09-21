import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/ai_document_service.dart';
import '../../core/services/local_storage_service.dart';
import '../../core/services/tts_service.dart';
import '../../data/models/ai_reader_model.dart';
import 'app_providers.dart';

final aiReaderProvider = NotifierProvider<AiReaderNotifier, AiReaderModel>(
  AiReaderNotifier.new,
);

class AiReaderNotifier extends Notifier<AiReaderModel> {
  late final AiDocumentService aiDocumentService;
  late final TtsService ttsService;
  late final LocalStorageService localStorageService;

  Future<void> _loadSettings() async {
    final rate = await localStorageService.getTtsRate();
    state = state.copyWith(ttsRate: rate);
  }

  Future<void> prepareDocumentForReading(String filePath) async {
    try {
      state = state.copyWith(
        isPreparing: true,
        errorMessage: null,
        readableText: null,
        summary: null,
        keyPoints: const [],
      );

      final result = await aiDocumentService.analyzeDocument(filePath);

      if (!result.isSuccess) {
        state = state.copyWith(
          isPreparing: false,
          errorMessage: result.errorMessage ?? 'Failed to prepare document.',
        );
        return;
      }

      state = state.copyWith(
        isPreparing: false,
        readableText: result.readableText,
        summary: result.summary,
        keyPoints: result.keyPoints,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isPreparing: false,
        errorMessage: 'An unexpected error occurred.',
      );
    }
  }

  Future<void> speakReadableText() async {
    final text = state.readableText;
    if (text == null || text.trim().isEmpty) {
      await ttsService.speak('No readable text available.');
      state = state.copyWith(isSpeaking: true);
      return;
    }

    await ttsService.speak(text);
    state = state.copyWith(isSpeaking: true);
  }

  Future<void> speakSummary() async {
    final summary = state.summary;
    if (summary == null || summary.trim().isEmpty) {
      await ttsService.speak('Summary not available.');
      state = state.copyWith(isSpeaking: true);
      return;
    }

    await ttsService.speak(summary);
    state = state.copyWith(isSpeaking: true);
  }

  Future<void> stopSpeaking() async {
    await ttsService.stop();
    state = state.copyWith(isSpeaking: false);
  }

  Future<void> updateTtsRate(double value) async {
    await localStorageService.saveTtsRate(value);
    await ttsService.setRate(value);
    state = state.copyWith(ttsRate: value);
  }

  void reset() {
    state = const AiReaderModel();
  }

  @override
  AiReaderModel build() {
    aiDocumentService = ref.read(aiDocumentServiceProvider);
    ttsService = ref.read(ttsServiceProvider);
    localStorageService = ref.read(localStorageServiceProvider);
    _loadSettings();
    return const AiReaderModel();
  }
}
