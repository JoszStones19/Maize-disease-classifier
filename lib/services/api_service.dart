import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../models/prediction_result.dart';
import 'storage_service.dart';

class ApiService {
  ApiService({StorageService? storageService})
      : _storageService = storageService ?? StorageService(),
        _dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 12),
            receiveTimeout: const Duration(seconds: 20),
            sendTimeout: const Duration(seconds: 20),
            headers: {'Content-Type': 'application/json'},
          ),
        );

  final Dio _dio;
  final StorageService _storageService;

  static const Map<String, String> _labelMap = {
    'Corn__Cercospora_leaf_spot Gray_leaf_spot': 'gray_leaf_spot',
    'Corn__Common_rust': 'common_rust',
    'Corn__Northern_Leaf_Blight': 'northern_leaf_blight',
    'Corn__healthy': 'healthy',
  };

  Future<String> _effectiveBaseUrl() async {
    final override = await _storageService.getBackendUrlOverride();
    if (override != null && override.trim().isNotEmpty) {
      return override.trim();
    }
    return ApiConstants.baseUrl;
  }

  Future<bool> checkHealth() async {
    if (ApiConstants.mockMode) return true;
    final baseUrl = await _effectiveBaseUrl();
    final response = await _dio.get('$baseUrl${ApiConstants.healthEndpoint}');
    return response.data['status'] == 'ok';
  }

  Future<PredictionResult> predictDisease(File imageFile) async {
    if (ApiConstants.mockMode) return _mockPredict();

    final base64Image = base64Encode(await imageFile.readAsBytes());
    final baseUrl = await _effectiveBaseUrl();

    final response = await _dio.post(
      '$baseUrl${ApiConstants.predictEndpoint}',
      data: {'image': base64Image},
    );

    final data = response.data as Map<String, dynamic>;

    // Map Kaggle labels → app labels
    data['disease'] = _labelMap[data['disease']] ?? data['disease'];
    data['alternatives'] = (data['alternatives'] as List).map((alt) {
      alt['label'] = _labelMap[alt['label']] ?? alt['label'];
      return alt;
    }).toList();

    return PredictionResult.fromJson(data);
  }

  Future<PredictionResult> _mockPredict() async {
    await Future<void>.delayed(const Duration(milliseconds: 850));
    const labels = [
      'northern_leaf_blight',
      'gray_leaf_spot',
      'common_rust',
      'healthy',
    ];
    final random = Random();
    final selected = labels[random.nextInt(labels.length)];

    if (selected == 'healthy') {
      return const PredictionResult(
        disease: 'healthy',
        confidence: 0.96,
        alternatives: [
          AlternativePrediction(label: 'common_rust', confidence: 0.02),
          AlternativePrediction(label: 'gray_leaf_spot', confidence: 0.01),
          AlternativePrediction(label: 'northern_leaf_blight', confidence: 0.01),
        ],
      );
    }

    if (selected == 'common_rust') {
      return const PredictionResult(
        disease: 'common_rust',
        confidence: 0.88,
        alternatives: [
          AlternativePrediction(label: 'gray_leaf_spot', confidence: 0.07),
          AlternativePrediction(label: 'healthy', confidence: 0.03),
          AlternativePrediction(label: 'northern_leaf_blight', confidence: 0.02),
        ],
      );
    }

    if (selected == 'gray_leaf_spot') {
      return const PredictionResult(
        disease: 'gray_leaf_spot',
        confidence: 0.91,
        alternatives: [
          AlternativePrediction(label: 'northern_leaf_blight', confidence: 0.05),
          AlternativePrediction(label: 'common_rust', confidence: 0.03),
          AlternativePrediction(label: 'healthy', confidence: 0.01),
        ],
      );
    }

    return const PredictionResult(
      disease: 'northern_leaf_blight',
      confidence: 0.92,
      alternatives: [
        AlternativePrediction(label: 'gray_leaf_spot', confidence: 0.05),
        AlternativePrediction(label: 'common_rust', confidence: 0.02),
        AlternativePrediction(label: 'healthy', confidence: 0.01),
      ],
    );
  }
}