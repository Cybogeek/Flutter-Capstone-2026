import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/ai_chat_model.dart';

class AiChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get chats =>
      _firestore.collection('ai_chats');

  Future<void> saveChat(AiChatMessage message) async {
    await chats.doc(message.id).set(message.toMap());
  }

  Future<List<AiChatMessage>> getChatsForPdf(String pdfId) async {
    if (pdfId.trim().isEmpty) return [];

    final snapshot = await chats
        .where('pdfId', isEqualTo: pdfId)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();

    if (snapshot.docs.isEmpty) return [];

    return snapshot.docs
        .map((doc) => AiChatMessage.fromMap(doc.data()))
        .toList();
  }
}
