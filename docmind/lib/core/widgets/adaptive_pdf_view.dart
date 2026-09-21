import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class AdaptivePdfView extends StatelessWidget {
  final PdfControllerPinch? pinchController;
  final PdfController? controller;
  final ValueChanged<int>? onPageChanged;
  final ValueChanged<PdfDocument>? onDocumentLoaded;

  const AdaptivePdfView({
    super.key,
    this.pinchController,
    this.controller,
    this.onPageChanged,
    this.onDocumentLoaded,
  });

  bool get _useStandardView {
    if (kIsWeb) return true;
    return Platform.isWindows;
  }

  @override
  Widget build(BuildContext context) {
    if (_useStandardView) {
      if (controller == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return PdfView(
        controller: controller!,
        onPageChanged: onPageChanged,
        onDocumentLoaded: onDocumentLoaded,
      );
    }

    if (pinchController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return PdfViewPinch(
      controller: pinchController!,
      onPageChanged: onPageChanged,
      onDocumentLoaded: onDocumentLoaded,
    );
  }
}
