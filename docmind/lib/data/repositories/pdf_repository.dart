import '../../core/services/local_storage_service.dart';
import '../../core/services/pdf_picker_service.dart';
import '../models/pdf_item_model.dart';

class PdfRepository {
  final PdfPickerService pickerService;
  final LocalStorageService localStorageService;

  PdfRepository({
    required this.pickerService,
    required this.localStorageService,
  });

  Future<List<PdfItemModel>> getLibrary() async {
    return localStorageService.getPdfLibrary();
  }

  Future<PdfItemModel?> pickAndAddPdf() async {
    final file = await pickerService.pickPdf();
    if (file == null) return null;

    final existing = await localStorageService.getPdfLibrary();
    final updated = [file, ...existing];
    await localStorageService.savePdfLibrary(updated);
    return file;
  }

  Future<void> saveLibrary(List<PdfItemModel> items) async {
    await localStorageService.savePdfLibrary(items);
  }

  Future<void> updateLastPage({
    required String pdfId,
    required int page,
  }) async {
    final library = await localStorageService.getPdfLibrary();
    final updated = library.map((item) {
      if (item.id == pdfId) {
        return item.copyWith(lastPage: page);
      }
      return item;
    }).toList();

    await localStorageService.savePdfLibrary(updated);
  }

  Future<void> removePdf(String pdfId) async {
    final library = await localStorageService.getPdfLibrary();
    final updated = library.where((item) => item.id != pdfId).toList();
    await localStorageService.savePdfLibrary(updated);
  }
}
