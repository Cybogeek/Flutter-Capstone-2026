import 'package:docmind/data/repositories/ai_chat_repository.dart';
import 'package:docmind/data/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/firebase_auth_service.dart';
import '../../core/services/local_storage_service.dart';
import '../../core/services/pdf_picker_service.dart';
import '../../core/services/tts_service.dart';
import '../../core/services/ai_document_service.dart';

final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final pdfPickerServiceProvider = Provider<PdfPickerService>((ref) {
  return PdfPickerService();
});

final ttsServiceProvider = Provider<TtsService>((ref) {
  final service = TtsService();
  service.init();
  return service;
});

final aiDocumentServiceProvider = Provider<AiDocumentService>((ref) {
  return AiDocumentService();
});
final appauthRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    authService: ref.read(firebaseAuthServiceProvider),
    localStorageService: ref.read(localStorageServiceProvider),
  );
});

final aiChatRepositoryProvider = Provider<AiChatRepository>((ref) {
  return AiChatRepository();
});
