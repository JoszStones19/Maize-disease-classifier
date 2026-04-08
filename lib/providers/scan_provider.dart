import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import '../models/prediction_result.dart';
import '../models/scan_record.dart';
import '../services/api_service.dart';
import 'history_provider.dart';

class ScanProvider extends ChangeNotifier {
  ScanProvider({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  final ApiService _apiService;
  final ImagePicker _imagePicker = ImagePicker();

  File? _selectedImage;
  PredictionResult? _result;
  bool _isLoading = false;
  String? _error;
  DateTime? _selectedAt;

  File? get selectedImage => _selectedImage;
  PredictionResult? get result => _result;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get selectedAt => _selectedAt;

  Future<bool> pickFromGallery() async {
    final picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    return _setImageFromXFile(picked);
  }

  Future<bool> takePhoto() async {
    final picked = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
      preferredCameraDevice: CameraDevice.rear,
    );
    return _setImageFromXFile(picked);
  }

  bool _setImageFromXFile(XFile? picked) {
    if (picked == null) return false;
    _selectedImage = File(picked.path);
    _result = null;
    _error = null;
    _selectedAt = DateTime.now();
    notifyListeners();
    return true;
  }

  Future<ScanRecord?> analyse(HistoryProvider historyProvider) async {
    if (_selectedImage == null) {
      _error = 'Please select a maize leaf image first.';
      notifyListeners();
      return null;
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final prediction = await _apiService.predictDisease(_selectedImage!);
      _result = prediction;

      final fileStats = await _selectedImage!.stat();
      final record = ScanRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        imagePath: _selectedImage!.path,
        fileName: p.basename(_selectedImage!.path),
        fileSize: fileStats.size,
        scannedAt: DateTime.now(),
        result: prediction,
      );

      await historyProvider.addRecord(record);
      return record;
    } catch (e) {
      _error = 'Analysis failed. Check your backend URL or network connection.';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void loadRecord(ScanRecord record) {
    _selectedImage = File(record.imagePath);
    _result = record.result;
    _selectedAt = record.scannedAt;
    _error = null;
    notifyListeners();
  }

  void clear() {
    _selectedImage = null;
    _result = null;
    _error = null;
    _selectedAt = null;
    notifyListeners();
  }
}
