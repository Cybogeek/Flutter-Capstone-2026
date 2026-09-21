import 'package:docmind/business/providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/ai_chat_model.dart';
import '../../data/repositories/ai_chat_repository.dart';
import '../../data/repositories/auth_repository.dart';

final aiChatRepositoryProvider = Provider<AiChatRepository>((ref) {
  return AiChatRepository();
});

final aiChatProvider =
    NotifierProvider<AiChatNotifier, AsyncValue<List<AiChatMessage>>>(
      AiChatNotifier.new,
    );

class AiChatNotifier extends Notifier<AsyncValue<List<AiChatMessage>>> {
  late final AiChatRepository repository;
  late final AuthRepository authRepo;

  Future<void> loadChats(String pdfId) async {
    if (pdfId.trim().isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    try {
      state = const AsyncValue.loading();
      final data = await repository.getChatsForPdf(pdfId);
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addLocalChat(AiChatMessage message) async {
    final current = state.asData?.value ?? const <AiChatMessage>[];
    state = AsyncValue.data([message, ...current]);
  }

  Future<void> askQuestion({
    required String pdfId,
    required String question,
    required String answer, // to avoid re-processing
  }) async {
    final userId = await authRepo.localStorageService.getCurrentUserId();
    if (userId == null) return;

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final message = AiChatMessage(
      id: id,
      pdfId: pdfId,
      question: question,
      answer: answer,
      timestamp: DateTime.now(),
    );

    try {
      await repository.saveChat(message);
      final current = state is AsyncData<List<AiChatMessage>>
          ? state.value
          : <AiChatMessage>[];
      state = AsyncValue.data([message, ...?current]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  @override
  AsyncValue<List<AiChatMessage>> build() {
    repository = ref.read(aiChatRepositoryProvider);
    authRepo = ref.read(appauthRepositoryProvider);
    const AsyncValue.loading();
    return const AsyncValue.data([]);
  }
}
