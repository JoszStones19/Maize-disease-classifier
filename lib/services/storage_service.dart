import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/scan_record.dart';

class StorageService {
  static const _historyKey = 'scan_history';
  static const _notificationsKey = 'notifications_enabled';
  static const _backendUrlKey = 'backend_url_override';

  Future<List<ScanRecord>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_historyKey) ?? [];
    return raw
        .map((item) => ScanRecord.fromJson(jsonDecode(item) as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveHistory(List<ScanRecord> records) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = records.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(_historyKey, encoded);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, value);
  }

  Future<String?> getBackendUrlOverride() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_backendUrlKey);
  }

  Future<void> setBackendUrlOverride(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_backendUrlKey, value);
  }

  Future<String> exportHistory(List<ScanRecord> records) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/maize_doctor_history.json');
    final payload = jsonEncode(records.map((record) => record.toJson()).toList());
    await file.writeAsString(payload);
    return file.path;
  }
}
