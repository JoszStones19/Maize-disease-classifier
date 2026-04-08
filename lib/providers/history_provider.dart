import 'package:flutter/foundation.dart';

import '../models/scan_record.dart';
import '../services/storage_service.dart';

class HistoryProvider extends ChangeNotifier {
  HistoryProvider({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  final StorageService _storageService;
  List<ScanRecord> _history = [];
  bool _isLoaded = false;
  bool _notificationsEnabled = true;
  String? _backendUrlOverride;

  List<ScanRecord> get history => _history;
  bool get isLoaded => _isLoaded;
  bool get notificationsEnabled => _notificationsEnabled;
  String? get backendUrlOverride => _backendUrlOverride;

  Future<void> init() async {
    if (_isLoaded) return;
    _history = await _storageService.loadHistory();
    _notificationsEnabled = await _storageService.getNotificationsEnabled();
    _backendUrlOverride = await _storageService.getBackendUrlOverride();
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> addRecord(ScanRecord record) async {
    _history = [record, ..._history];
    await _storageService.saveHistory(_history);
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _history = [];
    await _storageService.clearHistory();
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    await _storageService.setNotificationsEnabled(value);
    notifyListeners();
  }

  Future<void> setBackendUrlOverride(String value) async {
    _backendUrlOverride = value;
    await _storageService.setBackendUrlOverride(value);
    notifyListeners();
  }

  Future<String> exportHistory() => _storageService.exportHistory(_history);

  int get totalScans => _history.length;

  int get healthyLeaves =>
      _history.where((item) => item.result.disease == 'healthy').length;

  int get diseasesFound =>
      _history.where((item) => item.result.disease != 'healthy').length;

  String get mostScannedDisease {
    if (_history.isEmpty) return 'No scans yet';

    final counts = <String, int>{};
    for (final item in _history) {
      counts[item.result.disease] = (counts[item.result.disease] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }
}
