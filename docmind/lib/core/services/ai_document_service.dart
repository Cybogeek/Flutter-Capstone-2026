import 'dart:io';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:logger/logger.dart';

class AiDocumentResult {
  final String? readableText;
  final String? summary;
  final List<String> keyPoints;
  final String? errorMessage;
  final bool isSuccess;

  const AiDocumentResult({
    this.readableText,
    this.summary,
    this.keyPoints = const [],
    this.errorMessage,
    this.isSuccess = false,
  });
}

class AiDocumentService {
  final Logger _logger = Logger();
  GenerativeModel? _model;

  AiDocumentService() {
    _initializeModel();
  }

  void _initializeModel() {
    try {
      // Firebase AI Logic uses the Google AI backend by default. Firebase
      // must be initialized before this service is constructed.
      _model = FirebaseAI.googleAI().generativeModel(model: 'gemini-3.6-flash');
    } catch (e) {
      _logger.e('Failed to initialize Gemini model', error: e);
    }
  }

  Future<AiDocumentResult> analyzeDocument(String filePath) async {
    try {
      final model = _model;
      if (model == null) {
        return AiDocumentResult(
          errorMessage: 'AI model is not available.',
          isSuccess: false,
        );
      }

      final file = File(filePath);
      if (!file.existsSync()) {
        return AiDocumentResult(
          errorMessage: 'PDF file not found.',
          isSuccess: false,
        );
      }

      // Check file size (Gemini has limits)
      final fileSize = await file.length();
      const maxSize = 20 * 1024 * 1024; // 20 MB
      if (fileSize > maxSize) {
        return AiDocumentResult(
          errorMessage: 'PDF is too large (max 20 MB).',
          isSuccess: false,
        );
      }

      _logger.i('Starting PDF analysis: $filePath');

      final bytes = await file.readAsBytes();

      final prompt = '''
Analyze this PDF document and provide:

1. **Readable Text**: Extract and clean the main text content suitable for text-to-speech. Remove watermarks, page numbers, and formatting artifacts. Keep it natural and flowing. Return this under "READABLE_TEXT:" label.

2. **Summary**: Provide a concise 2-3 sentence summary of the document's main content and purpose. Return this under "SUMMARY:" label.

3. **Key Points**: List 3-5 most important key points from the document as bullet points. Return this under "KEY_POINTS:" label.

Format your response clearly with these three sections. Make the readable text clean and suitable for audio playback.
''';

      final response = await model.generateContent([
        Content.multi([
          TextPart(prompt),
          InlineDataPart('application/pdf', bytes),
        ]),
      ]);

      final responseText = response.text ?? '';
      if (responseText.isEmpty) {
        return AiDocumentResult(
          errorMessage: 'No response from AI model.',
          isSuccess: false,
        );
      }

      final result = _parseAiResponse(responseText);
      return result;
    } catch (e, st) {
      _logger.e('PDF analysis failed', error: e, stackTrace: st);
      return AiDocumentResult(
        errorMessage: 'Failed to analyze document: ${e.toString()}',
        isSuccess: false,
      );
    }
  }

  AiDocumentResult _parseAiResponse(String response) {
    try {
      String? readableText;
      String? summary;
      List<String> keyPoints = [];

      // Parse READABLE_TEXT
      final readableMatch = RegExp(
        r'READABLE_TEXT:\s*(.*?)(?=SUMMARY:|KEY_POINTS:|$)',
        dotAll: true,
      ).firstMatch(response);
      if (readableMatch != null) {
        readableText = readableMatch.group(1)?.trim();
      }

      // Parse SUMMARY
      final summaryMatch = RegExp(
        r'SUMMARY:\s*(.*?)(?=KEY_POINTS:|READABLE_TEXT:|$)',
        dotAll: true,
      ).firstMatch(response);
      if (summaryMatch != null) {
        summary = summaryMatch.group(1)?.trim();
      }

      // Parse KEY_POINTS
      final keyPointsMatch = RegExp(
        r'KEY_POINTS:\s*(.*?)(?=READABLE_TEXT:|SUMMARY:|$)',
        dotAll: true,
      ).firstMatch(response);
      if (keyPointsMatch != null) {
        final pointsText = keyPointsMatch.group(1)?.trim() ?? '';
        keyPoints = pointsText
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .map((line) => line.replaceFirst(RegExp(r'^[\s\-•*]+'), '').trim())
            .where((line) => line.isNotEmpty)
            .toList();
      }

      if (readableText == null || readableText.isEmpty) {
        return AiDocumentResult(
          errorMessage: 'Could not extract readable text from document.',
          isSuccess: false,
        );
      }

      return AiDocumentResult(
        readableText: readableText,
        summary: summary,
        keyPoints: keyPoints,
        isSuccess: true,
      );
    } catch (e) {
      _logger.e('Failed to parse AI response', error: e);
      return AiDocumentResult(
        errorMessage: 'Failed to process AI response.',
        isSuccess: false,
      );
    }
  }
}
