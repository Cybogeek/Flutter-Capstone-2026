import 'package:cloud_firestore/cloud_firestore.dart';

class AiChatMessage {
  final String id;
  final String pdfId;
  final String question;
  final String answer;
  final DateTime timestamp;

  AiChatMessage({
    required this.id,
    required this.pdfId,
    required this.question,
    required this.answer,
    required this.timestamp,
  });

  factory AiChatMessage.fromMap(Map<String, dynamic> map) {
    return AiChatMessage(
      id: map['id'] as String,
      pdfId: map['pdfId'] as String,
      question: map['question'] as String,
      answer: map['answer'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pdfId': pdfId,
      'question': question,
      'answer': answer,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
