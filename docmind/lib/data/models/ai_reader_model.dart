class AiReaderModel {
  final bool isPreparing;
  final bool isSpeaking;
  final String? readableText;
  final String? summary;
  final List<String> keyPoints;
  final String? errorMessage;
  final double ttsRate;

  const AiReaderModel({
    this.isPreparing = false,
    this.isSpeaking = false,
    this.readableText,
    this.summary,
    this.keyPoints = const [],
    this.errorMessage,
    this.ttsRate = 0.45,
  });

  AiReaderModel copyWith({
    bool? isPreparing,
    bool? isSpeaking,
    String? readableText,
    String? summary,
    List<String>? keyPoints,
    String? errorMessage,
    double? ttsRate,
  }) {
    return AiReaderModel(
      isPreparing: isPreparing ?? this.isPreparing,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      readableText: readableText ?? this.readableText,
      summary: summary ?? this.summary,
      keyPoints: keyPoints ?? this.keyPoints,
      errorMessage: errorMessage,
      ttsRate: ttsRate ?? this.ttsRate,
    );
  }
}
