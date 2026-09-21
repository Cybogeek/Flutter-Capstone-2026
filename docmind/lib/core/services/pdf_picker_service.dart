import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

import '../../data/models/pdf_item_model.dart';

class PdfPickerService {
  Future<PdfItemModel?> pickPdf() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result.isEmpty) return null;
    final file = result.first;
    final path = file.path;
    if (path == null) return null;

    final sizeInKb = ((await file.length()) / 1024).toStringAsFixed(0);

    return PdfItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: p.basename(path),
      path: path,
      createdAt: DateTime.now(),
      lastPage: 1,
      isAsset: false,
      fileSizeLabel: '$sizeInKb KB',
    );
  }
}
