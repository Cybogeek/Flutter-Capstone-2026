import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/pdf_item_model.dart';
import '../../data/repositories/pdf_repository.dart';
import 'app_providers.dart';

final pdfRepositoryProvider = Provider<PdfRepository>((ref) {
  return PdfRepository(
    pickerService: ref.read(pdfPickerServiceProvider),
    localStorageService: ref.read(localStorageServiceProvider),
  );
});

final libraryProvider =
    NotifierProvider<LibraryNotifier, AsyncValue<List<PdfItemModel>>>(
      LibraryNotifier.new,
    );

class LibraryNotifier extends Notifier<AsyncValue<List<PdfItemModel>>> {
  late final PdfRepository repository;

  LibraryNotifier();

  Future<void> loadLibrary() async {
    try {
      state = const AsyncValue.loading();
      final items = await repository.getLibrary();
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<PdfItemModel?> addPdf() async {
    final added = await repository.pickAndAddPdf();
    await loadLibrary();
    return added;
  }

  Future<void> updateLastPage({
    required String pdfId,
    required int page,
  }) async {
    await repository.updateLastPage(pdfId: pdfId, page: page);
    await loadLibrary();
  }

  Future<void> removePdf(String pdfId) async {
    await repository.removePdf(pdfId);
    await loadLibrary();
  }

  @override
  AsyncValue<List<PdfItemModel>> build() {
    repository = ref.read(pdfRepositoryProvider);
    const AsyncValue.loading();
    loadLibrary();
    return const AsyncValue.data([]);
  }
}
