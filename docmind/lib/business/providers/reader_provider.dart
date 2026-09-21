import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/local_storage_service.dart';
import '../../core/services/tts_service.dart';
import 'app_providers.dart';

class ReaderState {
  final bool isSpeaking;
  final double ttsRate;
  final int currentPage;

  const ReaderState({
    this.isSpeaking = false,
    this.ttsRate = 0.45,
    this.currentPage = 1,
  });

  ReaderState copyWith({bool? isSpeaking, double? ttsRate, int? currentPage}) {
    return ReaderState(
      isSpeaking: isSpeaking ?? this.isSpeaking,
      ttsRate: ttsRate ?? this.ttsRate,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

final readerProvider = NotifierProvider<ReaderNotifier, ReaderState>(
  ReaderNotifier.new,
);

class ReaderNotifier extends Notifier<ReaderState> {
  late final TtsService ttsService;
  late final LocalStorageService localStorageService;

  Future<void> loadSettings() async {
    final rate = await localStorageService.getTtsRate();
    await ttsService.setRate(rate);
    state = state.copyWith(ttsRate: rate);
  }

  Future<void> speakSample() async {
    await ttsService.speak(
      'Welcome to DOCMIND. This is your "AI" assisted reading mode.',
    );
    state = state.copyWith(isSpeaking: true);
  }

  Future<void> speakText(String text) async {
    await ttsService.speak(text);
    state = state.copyWith(isSpeaking: true);
  }

  Future<void> stopSpeaking() async {
    await ttsService.stop();
    state = state.copyWith(isSpeaking: false);
  }

  Future<void> updateRate(double value) async {
    await localStorageService.saveTtsRate(value);
    await ttsService.setRate(value);
    state = state.copyWith(ttsRate: value);
  }

  void setCurrentPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  @override
  ReaderState build() {
    ttsService = ref.read(ttsServiceProvider);
    localStorageService = ref.read(localStorageServiceProvider);
    loadSettings();
    return const ReaderState();
  }
}
