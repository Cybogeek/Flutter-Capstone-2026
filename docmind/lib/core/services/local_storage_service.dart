import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/pdf_item_model.dart';

class LocalStorageService {
  static const _userIdKey = 'user_id';
  static const _userEmailKey = 'user_email';
  static const _userNameKey = 'user_name';
  static const _isLoggedInKey = 'is_logged_in';

  static const _pdfLibraryKey = 'pdf_library';
  static const _ttsRateKey = 'tts_rate';

  Future<void> saveUser({
    required String id,
    required String email,
    String? name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, id);
    await prefs.setString(_userEmailKey, email);
    if (name != null) {
      await prefs.setString(_userNameKey, name);
    }
    await prefs.setBool(_isLoggedInKey, true);
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNameKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<void> savePdfLibrary(List<PdfItemModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = items.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList(_pdfLibraryKey, encoded);
  }

  Future<List<PdfItemModel>> getPdfLibrary() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_pdfLibraryKey) ?? [];
    return raw
        .map((e) => PdfItemModel.fromMap(jsonDecode(e) as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveTtsRate(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_ttsRateKey, value);
  }

  Future<double> getTtsRate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_ttsRateKey) ?? 0.45;
  }
}
